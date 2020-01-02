import 'package:ct/core/enums/challenge_status.dart';
import 'package:ct/core/models/challenge.dart';
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
                crossAxisAlignment: CrossAxisAlignment.end,
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
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    _buildChallenges(),
                    SizedBox(height: 20),
                    _buildRides(),
                    SizedBox(height: 20),
                    _buildFavourites(),
                  ],
                ),
              )
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
          _buildTile(
              Icons.track_changes, 'Challenges', _model.challenges.length),
          _buildTile(Icons.directions_bike, 'Rides', _model.rides.length),
          _buildTile(
              Icons.favorite_border,
              'Favourites',
              (_model.rides.where((r) => r.isFavourite).toList().length) +
                  (_model.challenges.where((c) => c.isFavourite).length)),
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
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Center(
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  title,
                  style: TextStyle(
                      color: AppTheme.primaryColor.withOpacity(0.8),
                      fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallenges() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50),
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
              Icons.track_changes,
              size: 200,
              color: AppTheme.background,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Challenges',
                    style: AppTheme.headline,
                  ),
                ),
                _buildRows(
                    'Completed', _getChallenges(ChallengeStatus.complete)),
                _buildRows(
                    'Pending', _getChallenges(ChallengeStatus.inProgress)),
                _buildRows(
                    'In Completed', _getChallenges(ChallengeStatus.inComplete)),
                _buildRows(
                    'Yet To Start', _getChallenges(ChallengeStatus.yetToStart)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRides() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50),
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
            right: -50,
            bottom: -50,
            child: Icon(
              Icons.directions_bike,
              size: 150,
              color: AppTheme.background,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Rides',
                    style: AppTheme.headline,
                  ),
                ),
                _buildRows('Total Rides', _model.rides.length.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavourites() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      height: 150,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: -50,
            right: -50,
            bottom: -50,
            child: Icon(
              Icons.favorite_border,
              size: 150,
              color: AppTheme.background,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Favouries',
                    style: AppTheme.headline,
                  ),
                ),
                _buildRows(
                    'Challenges',
                    _model.challenges
                        .where((r) => r.isFavourite)
                        .length
                        .toString()),
                _buildRows('Rides',
                    _model.rides.where((r) => r.isFavourite).length.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getChallenges(ChallengeStatus status) {
    List<ChallengeModel> ch = [];
    for (var c in _model.challenges) {
      var s = _getStatus(c);
      if (s == status) {
        ch.add(c);
      }
    }
    return ch.length.toString();
  }

  ChallengeStatus _getStatus(ChallengeModel challenge) {
    var date = DateTime.now();
    var start = challenge.startDate;
    var end = challenge.endDate;
    double covered = challenge.initial;
    if (start.isAfter(date)) {
      return ChallengeStatus.yetToStart;
    }
    var rides = _model.rides
        .where((ride) =>
            (ride.createdDate.day >= start.day &&
                ride.createdDate.month >= start.month &&
                ride.createdDate.year >= start.year) &&
            (ride.createdDate.day <= end.day &&
                ride.createdDate.month <= end.month &&
                ride.createdDate.year <= end.year))
        .toList();

    rides.forEach((f) => covered += f.kmCovered);

    if (covered >= challenge.target) {
      return ChallengeStatus.complete;
    }

    if ((end.difference(date).inDays + 1) == 0) {
      if (covered < challenge.target)
        return ChallengeStatus.inComplete;
      else
        return ChallengeStatus.complete;
    } else {
      return ChallengeStatus.inProgress;
    }
  }

  Widget _buildRows(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[Text(title), Text(value)],
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
