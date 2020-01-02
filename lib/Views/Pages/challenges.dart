import 'package:ct/Views/components/challenge_details/challenge_view.dart';
import 'package:ct/Views/components/context_tab_header.dart';
import 'package:ct/Views/components/nodata.dart';
import 'package:ct/Views/components/sub_title_bar.dart';
import 'package:ct/Views/router.dart';
import 'package:ct/core/enums/challenge_status.dart';
import 'package:ct/core/models/challenge.dart';
import 'package:ct/core/models/scoped/main.dart';
import 'package:ct/styles/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ChallengesPage extends StatefulWidget {
  @override
  _ChallengesPageState createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage>
    with TickerProviderStateMixin {
  ScrollController _scrollController = new ScrollController();
  AnimationController animationController;
  List<ChallengeModel> challenges = [];
  String search = '';
  MainModel main;
  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _getChallenges() {
    if (search.length <= 0) {
      challenges = main.challenges;
    }
    if (main.challengeFilter != null && main.challengeFilter.isSelected) {
      if (main.challengeFilter.isFavourite) {
        challenges = main.challenges.where((ride) => ride.isFavourite).toList();
      }
      if (main.challengeFilter.status == ChallengeStatus.complete) {
        challenges = _getFIlteredChallenges(ChallengeStatus.complete);
      } else if (main.challengeFilter.status == ChallengeStatus.inProgress) {
        challenges = _getFIlteredChallenges(ChallengeStatus.inProgress);
      } else if (main.challengeFilter.status == ChallengeStatus.inComplete) {
        challenges = _getFIlteredChallenges(ChallengeStatus.inComplete);
      } else if (main.challengeFilter.status == ChallengeStatus.yetToStart) {
        challenges = _getFIlteredChallenges(ChallengeStatus.yetToStart);
      }
    }
  }

  List<ChallengeModel> _getFIlteredChallenges(ChallengeStatus status) {
    List<ChallengeModel> ch = [];
    for (var c in challenges) {
      var s = _getStatus(c);
      if (s == status) {
        ch.add(c);
      }
    }
    return ch;
  }

  ChallengeStatus _getStatus(ChallengeModel challenge) {
    var date = DateTime.now();
    var start = challenge.startDate;
    var end = challenge.endDate;
    double covered = challenge.initial;
    if (start.isAfter(date)) {
      return ChallengeStatus.yetToStart;
    }

    var rides = main.rides
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

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        main = model;
        _getChallenges();
        return Scaffold(
          backgroundColor: AppTheme.background,
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        getAppBarUI(),
        Expanded(
          child: NestedScrollView(
            physics: BouncingScrollPhysics(),
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        getSearchBarUI(),
                        //getTimeDateUI(),
                      ],
                    );
                  }, childCount: 1),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: ContestTabHeader(
                    getFilterBarUI(),
                  ),
                ),
              ];
            },
            body: Container(
                color: AppTheme.background,
                child: challenges.length == 0
                    ? _noData()
                    : _buildList(challenges)),
          ),
        ),
      ],
    );
  }

  Widget _buildList(List<ChallengeModel> model) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        animationController.forward();
        return InkWell(
          onTap: () {
            _onItemTapped(model[index], index);
          },
          child: ChallengeView(
            animation: _calculateAnimation(index),
            animationController: animationController,
            challenge: model[index],
          ),
        );
      },
      itemCount: model.length,
    );
  }

  Animation<double> _calculateAnimation(int index) {
    var count = main.challenges.length > 10 ? 10 : main.challenges.length;
    return Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          (1 / count) * index,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
  }

  Widget _noData() {
    return NoData(
      icon: Icons.track_changes,
      message: 'No challenge available.',
      description: 'Click on the + icon to add new challenge.',
    );
  }

  void _onItemTapped(ChallengeModel model, int index) {
    main.selectedChallenge = model;
    Navigator.pushNamed(context, Router.challengeDetails);
  }

  Widget getAppBarUI() {
    return SubTitleBar(
      isPopup: false,
      title: 'Challenges',
      onTap: () {
        main.selectedChallenge = null;
        Navigator.pushNamed(context, Router.challenge);
      },
    );
  }

  Widget getFilterBarUI() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: AppTheme.background,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          color: AppTheme.background,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${challenges.length} challenges found',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, Router.challengeFilter);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Filters",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                Icon(Icons.sort, color: AppTheme.primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onChanged: (String txt) {
                      search = txt;
                    },
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: AppTheme.primaryColor,
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: "challenge name",
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  onSearch();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:
                      Icon(Icons.search, size: 20, color: AppTheme.background),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onSearch() {
    setState(() {
      if (search.length > 0) {
        challenges = main.challenges
            .where((c) => c.challengeName.contains(search))
            .toList();
      } else {
        challenges = main.challenges;
      }
    });
  }
}
