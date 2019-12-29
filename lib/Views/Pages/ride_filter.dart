import 'package:ct/Views/components/app_button.dart';
import 'package:ct/Views/components/sub_title_bar.dart';
import 'package:ct/core/models/ride_filter.dart';
import 'package:ct/core/models/scoped/main.dart';
import 'package:ct/styles/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class RideFilterPage extends StatefulWidget {
  @override
  _RideFilterPageState createState() => _RideFilterPageState();
}

class _RideFilterPageState extends State<RideFilterPage> {
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
                      _buildTodays(),
                      Divider(height: 1),
                      _buildDateFilters(),
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
    _model.rideFilter.isSelected = true;
    Navigator.pop(context);
  }

  Widget getAppBarUI() {
    return SubTitleBar(
      isPopup: true,
      title: 'Filters',
      onTap: () {
        _model.rideFilter = RideFilterModel.reset();
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
                  _model.rideFilter.isFavourite =
                      !_model.rideFilter.isFavourite;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      _model.rideFilter.isFavourite
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: _model.rideFilter.isFavourite
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

  Widget _buildTodays() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Today\'s Rides',
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
                  _model.rideFilter.isToday = !_model.rideFilter.isToday;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      _model.rideFilter.isToday
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: _model.rideFilter.isToday
                          ? AppTheme.primaryColor
                          : Colors.grey.withOpacity(0.6),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Show only today\'s rides',
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
                _model.rideFilter = null;
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

  Widget _buildDateFilters() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Date Filters',
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
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'From Date',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize:
                              MediaQuery.of(context).size.width > 360 ? 18 : 16,
                          fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '${DateTime.now().toString()}',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'To Date',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize:
                              MediaQuery.of(context).size.width > 360 ? 18 : 16,
                          fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '${DateTime.now().toString()}',
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
