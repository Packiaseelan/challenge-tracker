import 'package:ct/Views/components/app_background.dart';
import 'package:ct/Views/components/drawer.dart';
import 'package:ct/Views/components/header.dart';
import 'package:ct/utils/app-colors.dart';
import 'package:flutter/material.dart';

import '../components/alert.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: SideDrawer(),
        body: _buildBody(),
      ),
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => BeautifulAlertDialog(
        child: Icon(
          Icons.exit_to_app,
          size: 50,
          color: Colors.red,
        ),
        title: 'Are you sure?',
        message: 'Do you  want to exit an App?',
        acceptText: 'Exit',
        discardText: 'Cancel',
        onAcceptPressed: () => Navigator.of(context).pop(true),
        onDiscardPressed: () => Navigator.of(context).pop(false),
      ),
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
        onLeftPressed: () => _scaffoldKey.currentState.openDrawer(),
        title: 'Track Your Challenges',
      ),
    );
  }
}
