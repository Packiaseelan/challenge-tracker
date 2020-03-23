import 'package:ct/Views/Pages/index.dart';
import 'package:ct/Views/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class Router {
  static String initialRoute = '/';
  static String currentPage = initialRoute;

  static const String challenge = '/challenge';
  static const String challenges = '/challenges';
  static const String home = '/home';
  static const String welcome = '/welcome';
  static const String details = '/details';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String challengeDetails = '/challengeDetails';
  static const String addRide = '/addRide';
  static const String rides = '/rides';
  static const String rideFilter = '/rideFilter';
  static const String challengeFilter = '/challengeFilter';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    currentPage = settings.name;
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());

      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case welcome:
        return MaterialPageRoute(builder: (_) => WelcomePage());

      case details:
        return MaterialPageRoute(builder: (_) => DetailsPage());

      case challenges:
        return MaterialPageRoute(builder: (_) => ChallengesPage());

      case challenge:
        return MaterialPageRoute(builder: (_) => ChallengePage());

      case profile:
        return MaterialPageRoute(builder: (_) => ProfilePage());

      case challengeDetails:
        return MaterialPageRoute(builder: (_) => ChallengeDetails());

      case addRide:
        return MaterialPageRoute(
          builder: (_) => AddNewRidesPage(),
          fullscreenDialog: true,
        );

      case rideFilter:
        return MaterialPageRoute(
          builder: (_) => RideFilterPage(),
          fullscreenDialog: true,
        );

        case challengeFilter:
        return MaterialPageRoute(
          builder: (_) => ChallengeFilterPage(),
          fullscreenDialog: true,
        );

      case rides:
        return MaterialPageRoute(builder: (_) => RidesPage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
