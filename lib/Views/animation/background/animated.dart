import 'package:ct/core/enums/play-back.dart';
import 'package:ct/styles/appTheme.dart';
import 'package:flutter/material.dart';

import '../controlled-animaation.dart';
import '../multi-track-tween.dart';

class AnimatedBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("color1").add(
        Duration(seconds: 3),
        ColorTween(
          begin: AppTheme.primaryColor,//Color(0xff8a113a),
          end: Color(0xFF4A8B2A),//Colors.lightBlue.shade900,
        ),
      ),
      Track("color2").add(
        Duration(seconds: 3),
        ColorTween(
          begin: Color(0xFFCEDE00),
          end: Color(0xFF083A30),//Colors.blue.shade600,
        ),
      )
    ]);

    return ControlledAnimation(
      playback: Playback.MIRROR,
      tween: tween,
      duration: tween.duration,
      builder: (context, animation) {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [animation["color1"], animation["color2"]])),
        );
      },
    );
  }
}
