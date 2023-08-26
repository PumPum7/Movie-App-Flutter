// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

// Project imports:
import 'package:movie_faves/utils/router_utils.dart';

class NavigationBarBottom extends StatelessWidget {
  /// Constructs an [NavigationBarBottom].
  const NavigationBarBottom({
    required this.child,
    super.key,
  });

  /// The widget to display in the body of the Scaffold.
  /// In this sample, it is a Navigator.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: SalomonBottomBar(
        margin: EdgeInsets.fromLTRB( MediaQuery.of(context).size.width > 700 ? MediaQuery.of(context).size.width / 3 : 40, 5, MediaQuery.of(context).size.width > 700 ? MediaQuery.of(context).size.width / 3 : 40, 10),
        items: [
          SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text("Home"),
              selectedColor: Colors.purple),
          SalomonBottomBarItem(
              icon: const Icon(Icons.movie),
              title: const Text("Discover"),
              selectedColor: Colors.purple),
          SalomonBottomBarItem(
            icon: const Icon(Icons.favorite_border),
            title: const Text("Likes"),
            selectedColor: Colors.purple,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Profile"),
            selectedColor: Colors.purple,
          )
        ],
        currentIndex: _calculateSelectedIndex(context),
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/movie')) {
      return 0;
    }
    if (location.startsWith('/discover')) {
      return 1;
    }
    if (location.startsWith('/favorites')) {
      return 2;
    }
    if (location.startsWith('/profile')) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.goNamed(AppPage.home.routeName);
        break;
      case 1:
        context.goNamed(AppPage.discover.routeName);
        break;
      case 2:
        context.goNamed(AppPage.favorites.routeName);
        break;
      case 3:
        context.goNamed(AppPage.profile.routeName);
        break;
    }
  }
}
