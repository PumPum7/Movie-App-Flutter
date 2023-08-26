// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:movie_faves/globals/app_state_provider.dart';
import 'package:movie_faves/routes/create_account.dart';
import 'package:movie_faves/routes/discover.dart';
import 'package:movie_faves/routes/favorites.dart';
import 'package:movie_faves/routes/home.dart';
import 'package:movie_faves/routes/login.dart';
import 'package:movie_faves/routes/movie_details_page.dart';
import 'package:movie_faves/routes/onboarding.dart';
import 'package:movie_faves/routes/profile.dart';
import 'package:movie_faves/routes/profile_edit.dart';
import 'package:movie_faves/utils/router_utils.dart';
import 'package:movie_faves/widgets/navigation_bar_bottom.dart';

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
      initialLocation: AppPage.home.routePath,
      routes: [
        ShellRoute(
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return NavigationBarBottom(child: child);
          },
          routes: [
            GoRoute(
                path: AppPage.home.routePath,
                name: AppPage.home.routeName,
                builder: (context, state) => const Home(),
                routes: [
                  GoRoute(
                      path: AppPage.movie.routePath,
                      name: AppPage.movie.routeName,
                      builder: (context, state) => MovieDetailsPage(
                          movie: num.parse(state.pathParameters["movieId"]!)))
                ]),
            GoRoute(
                name: AppPage.discover.routeName,
                path: AppPage.discover.routePath,
                builder: (context, state) => const Discover()),
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
