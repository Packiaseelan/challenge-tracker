import 'package:ct/Views/Pages/add_ride.dart';
import 'package:ct/Views/Pages/challenge.dart';
import 'package:ct/Views/Pages/challenge_details.dart';
import 'package:ct/Views/Pages/challenges.dart';
import 'package:ct/Views/Pages/details.dart';
import 'package:ct/Views/Pages/home.dart';
import 'package:ct/Views/Pages/profile.dart';
import 'package:ct/Views/Pages/rides.dart';
import 'package:ct/Views/Pages/today-rides.dart';
import 'package:ct/Views/Pages/welcome.dart';
import 'package:flutter/material.dart';

class Router {
  static String initialRoute = '/';
  static String currentPage = initialRoute;

  static const String challenge = '/challenge';
  static const String challenges = '/challenges';
  static const String home = '/home';
  static const String details = '/details';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String todayRides = '/todayRides';
  static const String challengeDetails = '/challengeDetails';
  static const String addRide = '/addRide';
  static const String rides = '/rides';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    currentPage = settings.name;
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());

      case '/':
        return MaterialPageRoute(builder: (_) => WelcomePage());

      case details:
        return MaterialPageRoute(builder: (_) => DetailsPage());

      case challenges:
        return MaterialPageRoute(builder: (_) => ChallengesPage());

      case challenge:
        return MaterialPageRoute(builder: (_) => ChallengePage());

      case todayRides:
        return MaterialPageRoute(builder: (_) => TodayRidesPage());

      case profile:
        return MaterialPageRoute(builder: (_) => ProfilePage());

      case challengeDetails:
        return MaterialPageRoute(builder: (_) => ChallengeDetails());

      case addRide:
        return MaterialPageRoute(
          builder: (_) => AddNewRidesPage(),
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
