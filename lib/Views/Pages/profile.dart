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
  MainModel _model;
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
        _model = model;
        return Scaffold(
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
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.width / 2,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Icon(
                      Icons.person,
                      size: MediaQuery.of(context).size.width / 2,
                      color: Colors.black12,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      '${_model.detailsModel.firstName} ${_model.detailsModel.lastName}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              _buildTiles(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTiles() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildTile(Icons.track_changes, 'Challenges', _model.challenges.length),
          _buildTile(Icons.directions_bike, 'Rides', _model.rides.length),
          _buildTile(Icons.favorite_border, 'Favourites', _model.rides.where((r)=>r.isFavourite).toList().length),
        ],
      ),
    );
  }

  Widget _buildTile(IconData icon, String title, int count) {
    return Container(
      height: 70,
      width: 70,
      child: Stack(
        children: <Widget>[
          Icon(
            icon,
            size: 65,
            color: Colors.grey.withOpacity(0.2),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Center(
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                      color: AppTheme.primaryColor.withOpacity(0.8),
                      fontSize: 12),
                ),
              ],
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
