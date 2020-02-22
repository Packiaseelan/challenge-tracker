import 'dart:async';

import 'package:ct/Views/router.dart';
import 'package:ct/styles/appTheme.dart';
import 'package:ct/utils/ui-helper.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool _visible = true;

  AnimationController animationController;
  Animation<double> animation;
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed(Router.welcome);
  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    UIHelper.init(context);
    return Scaffold(
      body: Container(
        color: AppTheme.primaryColor,
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(100.0),
              child: Column(
                children: <Widget>[
                  Text('Challenge', style: AppTheme.sTitle),
                  Text('Tracker', style: AppTheme.sTitle),
                ],
              ),
            ),
            Expanded(child: Image.asset('assets/images/cycling.gif')),
            Text(
              'Powered By',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'HEX CREATORS',
              style: TextStyle(letterSpacing: 3, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
