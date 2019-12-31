import 'dart:math';

import 'package:ct/Views/animation/background/animated.dart';
import 'package:ct/Views/animation/components/animated-wave.dart';
import 'package:ct/Views/components/build-text.dart';
import 'package:ct/Views/components/welcome.dart';
import 'package:ct/Views/router.dart';
import 'package:ct/core/models/details.dart';
import 'package:ct/core/models/scoped/main.dart';
import 'package:ct/utils/greeting.dart';
import 'package:ct/utils/ui-helper.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  MainModel main;
  DetailsModel details;

  @override
  Widget build(BuildContext context) {
    UIHelper.init(context);
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        main = model;
        details = main.detailsModel;
        return Scaffold(
          body: details == null ? WelcomeView() : fancyBackground(),
        );
      },
    );
  }

  onBottom(Widget child) => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );

  Widget fancyBackground() {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: AnimatedBackground()),
        onBottom(AnimatedWave(
          height: 180,
          speed: 1.0,
        )),
        onBottom(AnimatedWave(
          height: 120,
          speed: 0.9,
          offset: pi,
        )),
        onBottom(AnimatedWave(
          height: 220,
          speed: 1.2,
          offset: pi / 2,
        )),
        Positioned.fill(child: _buildDetails()),
      ],
    );
  }

  Widget _buildDetails() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (Router.currentPage == Router.welcome) {
        Navigator.pushReplacementNamed(context, Router.home);
      }
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        SizedBox(
          height: 1,
        ),
        Container(
          child: Column(
            children: <Widget>[
              BuildText('Hello!'),
              SizedBox(
                height: 20,
              ),
              BuildText('${details.firstName} ${details.lastName}'),
              SizedBox(
                height: 20,
              ),
              BuildText('${getTimeGreeting()}')
            ],
          ),
        ),
        SizedBox(
          height: 1,
        ),
      ],
    );
  }
}
