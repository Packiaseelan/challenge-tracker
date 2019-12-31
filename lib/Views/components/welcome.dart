import 'package:ct/Views/animation/background/animated.dart';
import 'package:ct/Views/animation/components/particles.dart';
import 'package:ct/Views/components/build-text.dart';
import 'package:ct/Views/router.dart';
import 'package:flutter/material.dart';

class WelcomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: AnimatedBackground()),
        Positioned.fill(child: Particles(30)),
        Positioned.fill(child: _buildFreshLogin()),
        Positioned(
          right: 20,
          bottom: 20,
          child: IconButton(
            icon: Icon(
              Icons.arrow_forward,
              size: 50,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, Router.details);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFreshLogin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          height: 1,
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              BuildText('Welcome'),
              BuildText('to'),
              BuildText('Challenge Tracker'),
            ],
          ),
        ),
        Text(
          'Enter your details to start Challenge yourself',
          style: TextStyle(
            color: Colors.white,
          ),
          textScaleFactor: 1.3,
        ),
        SizedBox(
          height: 1,
        ),
      ],
    );
  }
}
