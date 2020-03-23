import 'package:ct/core/enums/challenge_status.dart';
import 'package:ct/core/models/challenge.dart';
import 'package:ct/core/models/scoped/main.dart';
import 'package:ct/styles/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:scoped_model/scoped_model.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  MainModel _model;
  @override
  Widget build(BuildContext context) {
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
                    _buildTiles(),
                    _buildToday(),
                    SizedBox(height: 20),
                    _buildChallenges(),
                    SizedBox(height: 20),
                    _buildRides(),
                    SizedBox(height: 20),
                    _buildFavourites(),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildToday() {
    double covered = 0;
    _model.todayRides.forEach((f) => covered += f.kmCovered);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      height: 100,
      child: Card(
        color: AppTheme.primaryColor,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              child: Icon(
                Feather.activity,
                size: 100,
                color: AppTheme.background.withOpacity(0.1),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Today ${_model.todayRides.length} Rides $covered kms covered',
                  style: AppTheme.headline.copyWith(color: AppTheme.background),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilepic() {
    return Row(
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
      margin: EdgeInsets.symmetric(horizontal: 30),
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
        children: <Widget>[
          Text(title),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          )
        ],
      ),
    );
  }
}
