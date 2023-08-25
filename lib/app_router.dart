// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:movie_faves/routes/create_account.dart';
import 'package:movie_faves/routes/profile_edit.dart';
import 'globals/app_state_provider.dart';
import 'routes/favorites.dart';
import 'routes/home.dart';
import 'routes/login.dart';
import 'routes/movie_details_page.dart';
import 'routes/onboarding.dart';
import 'routes/profile.dart';
import 'utils/router_utils.dart';
import 'widgets/scaffold_with_sidebar.dart';

class AppRouter {

  AppRouter({
    required this.appStateProvider,
    required this.prefs,
  });

  AppStateProvider appStateProvider;
  late SharedPreferences prefs;

  get router => _router;

  late final _router = GoRouter(
      refreshListenable: appStateProvider,
      initialLocation: AppPage.profileEdit.routePath,
      routes: [
        ShellRoute(
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return ScaffoldWithSidebar(child: child);
          },
          routes: [
            GoRoute(
                path: AppPage.home.routePath,
                name: AppPage.home.routeName,
                builder: (context, state) => const Home(title: "Movie App"),
                routes: [
                  GoRoute(
                      path: AppPage.movie.routePath,
                      name: AppPage.movie.routeName,
                      builder: (context, state) => MovieDetailsPage(
                          movie: num.parse(state.pathParameters["movieId"]!)))
                ]),
            GoRoute(
                name: AppPage.favorites.routeName,
                path: AppPage.favorites.routePath,
                builder: (context, state) => const FavoritesPage()),
            GoRoute(
                name: AppPage.profile.routeName,
                path: AppPage.profile.routePath,
                builder: (context, state) => const ProfilePage()),
            GoRoute(
                name: AppPage.profileEdit.routeName,
                path: AppPage.profileEdit.routePath,
                builder: (context, state) => const ProfileEditPage()),
          ],
        ),
        GoRoute(
            path: AppPage.login.routePath,
            name: AppPage.login.routeName,
            builder: (context, state) => const LoginScreen()),
        GoRoute(
            path: AppPage.createAccount.routePath,
            name: AppPage.createAccount.routeName,
            builder: (context, state) => const CreateAccount()),
        GoRoute(
            path: AppPage.onboard.routePath,
            name: AppPage.onboard.routeName,
            builder: (context, state) => const OnboardingPage()),
      ],
      redirect: (context, state) {
        final String onboardPath =
            state.namedLocation(AppPage.onboard.routeName);
        final String createAccountPath =
            state.namedLocation(AppPage.createAccount.routeName);
        final String loginPath = state.namedLocation(AppPage.login.routeName);

        bool isOnboarding = state.matchedLocation == onboardPath;

        bool toOnboard = prefs.containsKey('onBoardCount') ? false : true;

        if (toOnboard) {
          return isOnboarding ? null : onboardPath;
        }

        User? user = FirebaseAuth.instance.currentUser;

        if (user == null && state.matchedLocation != loginPath) {
          return createAccountPath;
        }

        return null;
      });
}
