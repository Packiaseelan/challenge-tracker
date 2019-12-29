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

class _ChallengesPageState extends State<ChallengesPage> {
  MainModel main;
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
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
            onTap: () {
              _onItemTapped(model[index], index);
            },
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: ClipOval(
                    child: Container(
                      height: 55,
                      width: 55,
                      color: AppTheme.primaryColor
                      //child: _getAvatar(model[index].path),
                    ),
                  ), //
                  title: Text(('Name   : ${model[index].challengeName}')),
                  subtitle: Text('Target : ${model[index].target.toString()}'),
                  // trailing: IconButton(
                  //     icon: Icon(Icons.delete_outline),
                  //     onPressed: () {
                  //       //_deleteDialog(context, dataList[index]);
                  //     }),
                ),
                Divider(),
              ],
            ));
      },
      itemCount: model.length,
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
