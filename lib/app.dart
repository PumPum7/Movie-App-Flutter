import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_router.dart';
import 'globals/app_state_provider.dart';

class MyApp extends StatefulWidget {
  SharedPreferences prefs;
  MyApp({required this.prefs, Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppStateProvider()),
        ProxyProvider<AppStateProvider, AppRouter>(
            update: (context, appStateProvider, _) => AppRouter(
                appStateProvider: appStateProvider, prefs: widget.prefs))
      ],
      child: Builder(
        builder: ((context) {
          final GoRouter router = Provider.of<AppRouter>(context).router;

          return ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp.router(
                theme: ThemeData(
                  primaryColor: Colors.white,
                  hintColor: Colors.black,
                  dividerColor: Colors.white54,
                  textTheme: Typography.englishLike2018.apply(
                      fontSizeFactor: 1.sp,
                      displayColor: Colors.black,
                      bodyColor: Colors.black),
                  colorScheme:
                  ColorScheme.fromSwatch(primarySwatch: Colors.grey)
                      .copyWith(background: const Color(0xFFE5E5E5)),
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                darkTheme: ThemeData(
                  primaryColor: Colors.black,
                  hintColor: Colors.white,
                  dividerColor: Colors.black12,
                  colorScheme:
                  ColorScheme.fromSwatch(primarySwatch: Colors.grey)
                      .copyWith(background: const Color(0xFF212121)),
                ),
                routeInformationParser: router.routeInformationParser,
                routerDelegate: router.routerDelegate,
                routeInformationProvider: router.routeInformationProvider,
              );
            },
          );
        }),
      ),
    );
  }
}