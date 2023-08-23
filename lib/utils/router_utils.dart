// Create enum to represent different routes
enum AppPage {
  onboard,
  auth,
  home,
  movie,
  profile,
  favorites
}


extension AppPageExtension on AppPage {
  // create path for routes
  String get routePath {
    switch (this) {
      case AppPage.home:
        return "/";
      case AppPage.onboard:
        return "/onboard";
      case AppPage.auth:
        return "/auth";
      case AppPage.movie:
        return "movie/:movieId";
      case AppPage.favorites:
        return "/favorites";
      case AppPage.profile:
        return "/profile";

      default:
        return "/";
    }
  }

  String get routeName {
    switch (this) {
      case AppPage.home:
        return "HOME";
      case AppPage.onboard:
        return "ONBOARD";
      case AppPage.auth:
        return "AUTH";
      case AppPage.movie:
        return "MOVIE";
      case AppPage.favorites:
        return "FAVORITES";
      case AppPage.profile:
        return "PROFILE";

      default:
        return "HOME";
    }
  }

// for page titles to use on appbar
  String get routePageTitle {
    switch (this) {
      case AppPage.home:
        return "Movie App";

      default:
        return "Movie App";
    }
  }
}
