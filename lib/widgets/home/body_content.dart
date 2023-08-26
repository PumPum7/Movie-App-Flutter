// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import 'package:movie_faves/widgets/home/category_movie_list.dart';
import 'package:movie_faves/widgets/home/search_field.dart';

class BodyContent extends StatelessWidget {
  BodyContent({
    super.key,
    required this.user,
  });

  late Future<User?> user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder(
            future: user,
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome ${snapshot.data?.displayName} 👋',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const Text("Lets enjoy some movies!")
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return const Icon(Icons.error_outline);
              } else {
                return const CircularProgressIndicator();
              }
            }),
        const Center(
            child: Padding(padding: EdgeInsets.all(20), child: SearchField())),
        DefaultTabController(
          length: 2,
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: SafeArea(
              child: Stack(
                children: [
                  SegmentedTabControl(
                    backgroundColor: Colors.transparent,
                    indicatorColor: Colors.transparent,
                    tabTextColor: Colors.black45,
                    textStyle: Theme.of(context).textTheme.bodyLarge,
                    height: 45,
                    tabs: const [
                      SegmentTab(
                        label: 'In Theaters',
                      ),
                      SegmentTab(
                        label: 'On TV',
                      ),
                    ],
                    selectedTabTextColor: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: TabBarView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Container(
                            alignment: Alignment.center,
                            child: const SidewayMovieList(category: "theater")),
                        Container(
                          alignment: Alignment.center,
                          child: const SidewayMovieList(category: "tv"),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
