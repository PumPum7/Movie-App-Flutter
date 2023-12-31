// Create enum to represent different routes
enum AppPage {
  onboard,
  home,
  discover,
  movie,
  profile,
  profileEdit,
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
      case AppPage.discover:
        return "/discover";
      case AppPage.onboard:
        return "/onboard";
      case AppPage.movie:
        return "movie/:movieId";
      case AppPage.favorites:
        return "/favorites";
      case AppPage.profile:
        return "/profile";
      case AppPage.profileEdit:
        return "/profile/edit";
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
      case AppPage.discover:
        return "DISCOVER";
      case AppPage.onboard:
        return "ONBOARD";
      case AppPage.movie:
        return "MOVIE";
      case AppPage.favorites:
        return "FAVORITES";
      case AppPage.profile:
        return "PROFILE";
      case AppPage.profileEdit:
        return "PROFILE_EDIT";
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
