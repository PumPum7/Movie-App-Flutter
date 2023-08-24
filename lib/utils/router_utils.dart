// Create enum to represent different routes
enum AppPage {
  onboard,
  home,
  movie,
  profile,
  favorites,
  login,
  createAccount
}


extension AppPageExtension on AppPage {
  // create path for routes
  String get routePath {
    switch (this) {
      case AppPage.home:
        return "/";
      case AppPage.onboard:
        return "/onboard";
      case AppPage.movie:
        return "movie/:movieId";
      case AppPage.favorites:
        return "/favorites";
      case AppPage.profile:
        return "/profile";
      case AppPage.login:
        return "/login";
      case AppPage.createAccount:
        return "/createAccount";

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
      case AppPage.movie:
        return "MOVIE";
      case AppPage.favorites:
        return "FAVORITES";
      case AppPage.profile:
        return "PROFILE";
      case AppPage.login:
        return "LOGIN";
      case AppPage.createAccount:
        return "CREATE_ACCOUNT";

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
