// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'globals/app_state_provider.dart';
import 'routes/authentication.dart';
import 'routes/favorites.dart';
import 'routes/home.dart';
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
      initialLocation: "/",
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
                path: AppPage.auth.routePath,
                name: AppPage.auth.routeName,
                builder: (context, state) => const AuthenticationPage())
          ],
        ),
        GoRoute(
            path: AppPage.onboard.routePath,
            name: AppPage.onboard.routeName,
            builder: (context, state) => const OnboardingPage()),
      ],
      redirect: (context, state) {
        final String onboardPath =
            state.namedLocation(AppPage.onboard.routeName);

        bool isOnboarding = state.matchedLocation == onboardPath;

        bool toOnboard = prefs.containsKey('onBoardCount') ? false : true;

        if (toOnboard) {
          return isOnboarding ? null : onboardPath;
        }
        return null;
      });
}
