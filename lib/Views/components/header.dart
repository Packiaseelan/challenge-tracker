import 'package:ct/utils/app-colors.dart';
import 'package:flutter/material.dart';

class HeaderView extends StatelessWidget {
  final IconData leftIcon;
  final Function onLeftPressed;
  final IconData rightIcon;
  final Function onRightPressed;
  final String title;
  HeaderView({
    this.title,
    this.leftIcon,
    this.rightIcon,
    this.onLeftPressed,
    this.onRightPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: headerColor,
      child: _buildHeader(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Center(
              child: IconButton(
                icon: Icon(leftIcon,color: Colors.white,),
                onPressed: onLeftPressed,
              ),
            ),
          ),
          Center(
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w300, color: Colors.white),
              textScaleFactor: 2,
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Center(
              child: (rightIcon == null)
                  ? SizedBox(width: 30, height: 30,)
                  : IconButton(
                      icon: Icon(rightIcon,color: Colors.white,),
                      onPressed: onRightPressed,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
