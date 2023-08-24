// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';

// Project imports:
import '../globals/app_state_provider.dart';
import '../utils/router_utils.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

void onSubmitDone(AppStateProvider stateProvider, BuildContext context) {
  // When user pressed skip/done button we'll finally set onboardCount integer
  stateProvider.hasOnboarded();
  // After that onboard state is done we'll go to homepage.
  GoRouter.of(context).goNamed(AppPage.createAccount.routeName);
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    final appStateProvider = Provider.of<AppStateProvider>(context);
    FlutterNativeSplash.remove();

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: TextStyle(fontSize: 19.0),
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      onDone: () => onSubmitDone(appStateProvider, context),
      showDoneButton: true,
      showBackButton: true,
      showNextButton: true,
      showSkipButton: false,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      back: const Icon(Icons.arrow_back),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      skipOrBackFlex: 0,
      nextFlex: 0,
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Theme.of(context).colorScheme.secondary,
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
      pages: [
        PageViewModel(
          title: "Discover and Collect Your Favorite Movies",
          body:
              "Welcome to MovieFaves, your ultimate movie companion. Create personalized lists of your favorite films, explore detailed information about each movie, and easily share your cinematic passion with friends. Let's dive into the world of movies together!",
          image: const Center(
            child: Icon(
              Icons.movie,
              size: 100.0,
              color: Color(0xff001F3F),
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Dive into Movie Details",
          body:
              "Explore in-depth information about each movie. From plot summaries and cast details to reviews and ratings, MovieFaves offers a comprehensive look at your favorite films. Get ready to enhance your movie knowledge like never before!",
          image: const Center(
            child: Icon(
              Icons.book,
              size: 100.0,
              color: Color(0xffFFD700),
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Share Your Movie Passion",
          body:
              "Spread the love for movies! Easily share your curated movie lists with friends and family. Whether it's a recommendation, a favorite list, or a themed collection, MovieFaves lets you connect and inspire fellow movie enthusiasts.",
          image: const Center(
            child: Icon(Icons.offline_share,
                size: 100.0, color: Color(0xff2ECC40)),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Let's Get Started!",
          image: const Center(
            child: Icon(Icons.check, size: 100.0, color: Color(0xffB10DC9)),
          ),
          bodyWidget: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(4.0),
                width: MediaQuery.of(context).size.width * 0.9,
                child: const Text(
                    softWrap: true,
                    style: TextStyle(fontSize: 19.0),
                    textAlign: TextAlign.center,
                    "To get the most out of MovieFaves, log in to your account. Don't have an account? No worries – you can create one in a few simple steps. Start curating your movie collections, exploring film details, and sharing your passion today!"),
              ),
              ElevatedButton(
                  onPressed: () => onSubmitDone(appStateProvider, context),
                  child: const Text("Get started!")),
            ],
          ),
          decoration: pageDecoration,
        )
      ],
    );
  }
}
