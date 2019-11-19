import 'package:ct/Views/Pages/challenge-details.dart';
import 'package:ct/Views/Pages/challenge.dart';
import 'package:ct/Views/Pages/challenges.dart';
import 'package:ct/Views/Pages/daily-record.dart';
import 'package:ct/Views/Pages/details.dart';
import 'package:ct/Views/Pages/home.dart';
import 'package:ct/Views/Pages/profile.dart';
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
  static const String dailyRecord = '/dailyRecord';
  static const String todayRides = '/todayRides';
  static const String challengeDetails = '/challengeDetails';

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

      case dailyRecord:
        return MaterialPageRoute(builder: (_) => DailyRecordPage());

      case todayRides:
        return MaterialPageRoute(builder: (_) => TodayRidesPage());

      case challengeDetails:
        return MaterialPageRoute(builder: (_) => ChallengeDetailsPage());

      case profile:
        return MaterialPageRoute(builder: (_) => ProfilePage());

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
