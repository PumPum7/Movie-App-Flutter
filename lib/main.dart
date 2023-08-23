import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/routes/home.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/routes/movie_details_page.dart';
import 'package:movie_app/widgets/scaffold_with_sidebar.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future main() async {
  await dotenv.load(fileName: "assets/config/.env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top],
  );

  runApp(const MyApp());
}

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final _router =
    GoRouter(navigatorKey: _rootNavigatorKey, initialLocation: "/", routes: [
  ShellRoute(
    navigatorKey: _shellNavigatorKey,
    builder: (BuildContext context, GoRouterState state, Widget child) {
      return ScaffoldWithSidebar(child: child);
    },
    routes: [
      GoRoute(
          path: "/",
          builder: (context, state) => const Home(title: "Movie App"),
          routes: [
            GoRoute(
                path: "movie/:movieId",
                builder: (context, state) => MovieDetailsPage(
                    movie: num.parse(state.pathParameters["movieId"]!)))
          ])
    ],
  )
]);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static State of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'MovieApp',
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            primaryColor: Colors.white,
            hintColor: Colors.black,
            dividerColor: Colors.white54,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp, displayColor: Colors.black, bodyColor: Colors.black),
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
                .copyWith(background: const Color(0xFFE5E5E5)),
          ),
          darkTheme: ThemeData(
            primaryColor: Colors.black,
            hintColor: Colors.white,
            dividerColor: Colors.black12,
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
                .copyWith(background: const Color(0xFF212121)),
          ),
          themeMode: _themeMode,
          routerConfig: _router,
        );
      },
    );
  }
}
