import 'package:ct/Views/components/header.dart';
import 'package:ct/Views/components/nodata.dart';
import 'package:ct/Views/router.dart';
import 'package:ct/core/models/daily-record.dart';
import 'package:ct/core/models/scoped/main.dart';
import 'package:ct/utils/app-colors.dart';
import 'package:ct/utils/converter.dart';
import 'package:ct/utils/ui-helper.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ChallengeDetailsPage extends StatefulWidget {
  @override
  _ChallengeDetailsPageState createState() => _ChallengeDetailsPageState();
}

class _ChallengeDetailsPageState extends State<ChallengeDetailsPage> {
  MainModel main;
  List<DailyRecordModel> rides = [];
  double kms = 0;
  int duration;
  int completed;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      main = model;
      _getRides();
      return Scaffold(
        backgroundColor: pageBackgroundColor,
        body: _buildBody(),
      );
    });
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        HeaderView(
          title: main.selectedChallenge.challengeName,
          leftIcon: Icons.arrow_back_ios,
          onLeftPressed: () {
            Navigator.of(context).pop();
          },
          rightIcon: Icons.edit,
          onRightPressed: () {
            Navigator.pushNamed(context, Router.challenge);
          },
        ),
        _buildDetails(),
        Container(
          height: (UIHelper.safeAreaHeight * 0.74),
          child: rides.length > 0 ? _buildList(rides) : _noData(),
        ),
      ],
    );
  }

  Widget _buildDetails() {
    duration = main.selectedChallenge.endDate
        .difference(main.selectedChallenge.startDate)
        .inDays;
    completed =
        (DateTime.now().difference(main.selectedChallenge.startDate).inDays) +
            1;
    return Container(
      height: UIHelper.safeAreaHeight * 0.16,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildText(
                    ' StartDate: ${dts(main.selectedChallenge.startDate)}'),
                _buildText(' EndDate: ${dts(main.selectedChallenge.endDate)}'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildText(' Duration: $duration days'),
                _buildText(' Remaining: ${duration - completed} days'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildText(
                ' Average distance for remaining days: ${getAverageForRemainingDays()} kms'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildText(
                ' Distance Covered: $kms / ${main.selectedChallenge.target} kms'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildText(' Number of rides: ${rides.length}'),
          ),
        ],
      ),
    );
  }

  Widget _noData() {
    return NoData(
      icon: Icons.directions_bike,
      message: 'No rides available for this challenge.',
      description: '',
    );
  }

  Widget _buildList(List<DailyRecordModel> model) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.directions_bike,
                color: Colors.grey,
              ),
              title: Text(('To: ${model[index].rideTo}' ?? '')),
              subtitle: Text('${dts(model[index].createdDate)}'),
              trailing: Text('Km :${model[index].kmCovered.toString()}' ?? ''),
            ),
            Divider(),
          ],
        );
      },
      itemCount: model.length,
    );
  }

  Widget _buildText(String text) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text),
      ),
    );
  }

  void _getRides() {
    var start = main.selectedChallenge.startDate;
    var end = main.selectedChallenge.endDate;

    rides = main.dailyRecords
        .where((ride) =>
            (ride.createdDate.day >= start.day &&
                ride.createdDate.month >= start.month &&
                ride.createdDate.year >= start.year) &&
            (ride.createdDate.day <= end.day &&
                ride.createdDate.month <= end.month &&
                ride.createdDate.year <= end.year))
        .toList();

    rides.forEach((f) => kms += f.kmCovered);
  }

  String getAverageForRemainingDays() {
    return ((main.selectedChallenge.target -
            (main.selectedChallenge.initial + kms)) /
        (duration - completed)).toStringAsFixed(2);
  }
}
