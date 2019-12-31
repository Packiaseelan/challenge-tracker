import 'package:ct/Views/components/challenge_details/challenge_view.dart';
import 'package:ct/Views/components/nodata.dart';
import 'package:ct/Views/components/sub_title_bar.dart';
import 'package:ct/Views/router.dart';
import 'package:ct/core/models/challenge.dart';
import 'package:ct/core/models/scoped/main.dart';
import 'package:ct/styles/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ChallengesPage extends StatefulWidget {
  @override
  _ChallengesPageState createState() => _ChallengesPageState();
}

class _ChallengesPageState extends State<ChallengesPage> with TickerProviderStateMixin {
  AnimationController animationController;
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
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        main = model;
        return Scaffold(body: _buildBody());
      },
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        getAppBarUI(),
        Expanded(
          child: Container(
            color: AppTheme.background,
            child: main.challenges.length > 0
                ? _buildList(main.challenges)
                : _noData(),
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
}
