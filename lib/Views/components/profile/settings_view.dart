import 'package:ct/core/models/scoped/main.dart';
import 'package:ct/styles/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  MainModel _model;
  MediaQueryData queryData;
  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        _model = model;
        return Column(
          children: <Widget>[
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    _buildProfilepic(),
                    _buildName(),
                    SizedBox(height: 20),
                    _connectGoogle('Google'),
                    SizedBox(height: 20),
                    _connectGoogle('Starva'),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildProfilepic() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.width / 2,
          width: MediaQuery.of(context).size.width / 2,
          color: AppTheme.primaryColor.withOpacity(0.3),
          child: Stack(
            children: <Widget>[
              _getProfilePic(),
              Center(
                  child: Icon(
                Icons.camera_alt,
                color: Colors.white24,
                size: 70,
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getProfilePic() {
    return Icon(
      Icons.person,
      size: MediaQuery.of(context).size.width / 2,
      color: Colors.black12,
    );
  }

  Widget _buildForm() {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Firstname',
              hintStyle: AppTheme.headline,
              border: InputBorder.none,
            ),
            style: AppTheme.headline,
            initialValue: _model.detailsModel.firstName,
          ),
          Text('First Name'),
          SizedBox(height: queryData.size.width * 0.05),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Lastname',
              hintStyle: AppTheme.headline,
              border: InputBorder.none,
            ),
            style: AppTheme.headline,
            initialValue: _model.detailsModel.lastName,
          ),
          Text('Last Name'),
        ],
      ),
    );
  }

  Widget _buildName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      height: 200,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: -50,
            right: -50,
            bottom: -50,
            child: Icon(
              Icons.person_outline,
              size: 200,
              color: AppTheme.background,
            ),
          ),
          Container(padding: EdgeInsets.all(20), child: _buildForm()),
        ],
      ),
    );
  }

  Widget _connectGoogle(String title) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      height: 100,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: -50,
            right: -25,
            bottom: -50,
            child: Icon(
              Icons.swap_horizontal_circle,
              size: 150,
              color: AppTheme.background,
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Container(
              padding: EdgeInsets.all(15),
              child: Text(
                'Connect via $title',
                style: AppTheme.headline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
