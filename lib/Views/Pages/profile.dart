import 'package:ct/Views/components/profile/profile_view.dart';
import 'package:ct/Views/components/profile/settings_view.dart';
import 'package:ct/core/models/scoped/main.dart';
import 'package:ct/styles/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  PageController _controller;
  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          backgroundColor: AppTheme.background,
          body: PageView(
            controller: _controller,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              _getProfile(),
              _getSettings(),
            ],
          ),
        );
      },
    );
  }

  void _updateController(int page) {
    _controller.animateToPage(
      page,
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

  Widget _getProfile() {
    return Container(
      child: Stack(
        children: <Widget>[
          ProfileView(),
          Positioned(
            top: 50,
            right: 0,
            child: InkWell(
              onTap: () {
                _updateController(1);
              },
              child: Container(
                height: 45,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.red,
                      offset: Offset(0, 2),
                    ),
                  ],
                  color: AppTheme.primaryColor,
                ),
                child: Icon(
                  Icons.mode_edit,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSettings() {
    return Container(
      child: Stack(
        children: <Widget>[
          SettingsView(),
          Positioned(
            top: 50,
            left: 0,
            child: InkWell(
              onTap: () {
                _updateController(0);
              },
              child: Container(
                height: 45,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.red,
                      offset: Offset(0, 2),
                    ),
                  ],
                  color: AppTheme.primaryColor,
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
