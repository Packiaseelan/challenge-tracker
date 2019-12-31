import 'package:ct/styles/appTheme.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[],
      ),
    );
  }
}
