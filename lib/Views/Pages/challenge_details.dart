import 'package:ct/Views/components/challenge_details/details_view.dart';
import 'package:ct/Views/components/challenge_details/rides_listview.dart';
import 'package:ct/Views/components/challenge_details/titleView.dart';
import 'package:ct/core/models/daily-record.dart';
import 'package:ct/core/models/scoped/main.dart';
import 'package:ct/styles/appTheme.dart';
import 'package:ct/styles/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:intl/intl.dart';

class ChallengeDetails extends StatefulWidget {
  @override
  _ChallengeDetailsState createState() => _ChallengeDetailsState();
}

class _ChallengeDetailsState extends State<ChallengeDetails>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  AnimationController animationController;

  MainModel _model;
  List<DailyRecordModel> rides = [];
  double kms = 0;

  List<Widget> listViews = List<Widget>();
  var scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    topBarAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn),
      ),
    );

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData() {
    var count = 9;

    listViews = [];

    listViews.add(
      TitleView(
        titleTxt: _model.selectedChallenge.challengeName,
        subTxt: 'Options',
        onPressed: () {},
        animation: Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn),
          ),
        ),
        animationController: animationController,
      ),
    );
    listViews.add(getTimeDateUI());
    listViews.add(
      DetailsView(
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController,
            curve:
                Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: animationController,
      ),
    );

    listViews.add(
      TitleView(
        titleTxt: 'Rides',
        subTxt: 'Add Ride',
        onPressed: () {},
        animation: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController,
            curve:
                Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: animationController,
      ),
    );

    rides.sort((b, a) => a.createdDate.compareTo(b.createdDate));

    listViews.add(
      RidesListView(
        mainScreenAnimation: Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: animationController,
                curve: Interval((1 / count) * 3, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: animationController,
        rides: rides,
      ),
    );
  }

  void _getRides() {
    var start = _model.selectedChallenge.startDate;
    var end = _model.selectedChallenge.endDate;

    rides = _model.dailyRecords
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

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        _model = model;
        _getRides();
        addAllListData();
        return Container(
          color: AppTheme.background,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: <Widget>[
                getMainListViewUI(),
                getAppBarUI(),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              animationController.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: new Transform(
                transform: new Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey.withOpacity(0.4 * topBarOpacity),
                          offset: Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16 - 8.0 * topBarOpacity,
                          bottom: 12 - 8.0 * topBarOpacity,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Challenge ",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            _buildStatus()
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Widget getTimeDateUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 8, top: 15, bottom: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Start date",
                          style: dateTitle,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "${DateFormat("dd, MMM, yyyy").format(_model.selectedChallenge.startDate)}",
                          style: dateSubTitle,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Container(
              width: 1,
              height: 42,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 8, top: 15, bottom: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "End date",
                          style: dateTitle,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "${DateFormat("dd, MMM, yyyy").format(_model.selectedChallenge.endDate)}",
                          style: dateSubTitle,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Container(
              width: 1,
              height: 42,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 8, top: 15, bottom: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Duration",
                          style: dateTitle,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "${_getDurationDays()}",
                          style: dateSubTitle,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatus() {
    int duration = _model.selectedChallenge.endDate
            .difference(_model.selectedChallenge.startDate)
            .inDays +
        1;
    int completed =
        (DateTime.now().difference(_model.selectedChallenge.startDate).inDays) +
            1;

    int remaining = duration - completed;

    double res = _model.selectedChallenge.target -
        (kms + _model.selectedChallenge.initial);

    String str = res > 0 ? 'Incomplete' : '';

    if (remaining > 0) return SizedBox();
    return Text(
      '$str closed',
      style: TextStyle(color: Colors.red),
    );
  }

  String _getDurationDays() {
    int d = _model.selectedChallenge.endDate
            .difference(_model.selectedChallenge.startDate)
            .inDays +
        1;
    return '$d days';
  }
}
