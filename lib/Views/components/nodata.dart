import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  final IconData icon;
  final String message;
  final String description;
  NoData({this.icon, this.message, this.description});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.grey,
              size: 100,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              message,
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              description,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
