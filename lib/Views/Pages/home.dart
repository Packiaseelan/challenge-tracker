import 'package:ct/Views/components/app_background.dart';
import 'package:ct/Views/components/drawer.dart';
import 'package:ct/Views/components/header.dart';
import 'package:ct/utils/app-colors.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideDrawer(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        AppBackground(
          firstColor: firstCircleColor,
          secondColor: secondCircleColor,
          thirdColor: thirdCircleColor,
        ),
        _buildHeader(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      child: HeaderView(
        leftIcon: Icons.menu,
        onLeftPressed: () {
          _scaffoldKey.currentState.openDrawer();
        },
        title: 'Track Your Challenges',
      ),
    );
  }
}
