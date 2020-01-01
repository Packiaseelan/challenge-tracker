import 'package:ct/Views/components/app_button.dart';
import 'package:ct/Views/components/sub_title_bar.dart';
import 'package:ct/core/models/challenge_filter.dart';
import 'package:ct/core/models/scoped/main.dart';
import 'package:ct/styles/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ChallengeFilterPage extends StatefulWidget {
  @override
  _ChallengeFilterPageState createState() => _ChallengeFilterPageState();
}

class _ChallengeFilterPageState extends State<ChallengeFilterPage> {
  MainModel _model;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      _model = model;
      return Container(
        color: AppTheme.background,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: <Widget>[
              getAppBarUI(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      favFilter(),
                      Divider(height: 1),
                      _buildReset(),
                      Divider(height: 1),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1,
              ),
              AppButton(
                title: 'Apply',
                onPressed: onApply,
              ),
            ],
          ),
        ),
      );
    });
  }

  void onApply() {
    _model.challengeFilter.isSelected = true;
    Navigator.pop(context);
  }

  Widget getAppBarUI() {
    return SubTitleBar(
      isPopup: true,
      title: 'Filters',
      onTap: () {
        _model.challengeFilter = ChallengeFilterModel.reset();
        Navigator.pop(context);
      },
    );
  }

  Widget favFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Favourite Rides',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              onTap: () {
                setState(() {
                  _model.challengeFilter.isFavourite =
                      !_model.challengeFilter.isFavourite;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      _model.challengeFilter.isFavourite
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: _model.challengeFilter.isFavourite
                          ? AppTheme.primaryColor
                          : Colors.grey.withOpacity(0.6),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Show only favourite rides',
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }

  Widget _buildReset() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Reset Filters',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              onTap: () {
                _model.challengeFilter = ChallengeFilterModel.reset();
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Click here to Reset filters',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}