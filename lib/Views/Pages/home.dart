import 'package:ct/Views/Pages/index.dart';
import 'package:ct/Views/components/tab_bar/index.dart';
import 'package:ct/core/models/scoped/main.dart';
import 'package:ct/styles/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../components/alert.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  MainModel _model;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      _model = model;
      return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          key: _scaffoldKey,
          body: _getBody(),
          bottomNavigationBar: FancyTabBar(),
        ),
      );
    });
  }

  Widget _getBody() {
    switch (_model.currentHomePage) {
      case 0:
        return ChallengesPage();
      case 1:
        return RidesPage();
      case 2:
        return ProfilePage();
      default:
        return Container(
          color: AppTheme.background,
          child: Center(
            child: Text('Undefined Page'),
          ),
        );
    }
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
        acceptText: 'Yes',
        discardText: 'No',
        onAcceptPressed: () => Navigator.of(context).pop(true),
        onDiscardPressed: () => Navigator.of(context).pop(false),
      ),
    );
  }
}
