// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// Project imports:
import 'package:movie_faves/classes/trending_media.dart';
import 'package:movie_faves/routes/profile.dart';
import 'package:movie_faves/utils/fetch_trending.dart';
import 'package:movie_faves/widgets/home/body_content.dart';
import 'package:movie_faves/widgets/home/panel_content.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<TrendingMedia> futureMovie;
  late Future<User?> _currentUser;

  @override
  void initState() {
    super.initState();
    futureMovie = fetchTrending("all");
    _currentUser = getCurrentUser();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Movie Faves',
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 10,
          ),
          resizeToAvoidBottomInset: false,
          body: FutureBuilder<TrendingMedia>(
            future: futureMovie,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                FlutterNativeSplash.remove();

                return SlidingUpPanel(
                  renderPanelSheet: false,
                  minHeight: MediaQuery.of(context).size.height / 2.7,
                  maxHeight: MediaQuery.of(context).size.height,
                  // panel
                  panel: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 253, 253, 253),
                        borderRadius: BorderRadius.all(Radius.circular(24.0)),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20.0,
                            color: Colors.grey,
                          ),
                        ]),
                    margin: const EdgeInsets.all(24.0),
                    child: PanelContent(
                      data: snapshot.data,
                    ),
                  ),
                  body: BodyContent(
                    user: _currentUser,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      );
}
