import 'package:ct/Views/components/context_tab_header.dart';
import 'package:ct/Views/components/nodata.dart';
import 'package:ct/Views/components/rides_view.dart';
import 'package:ct/Views/components/sub_title_bar.dart';
import 'package:ct/Views/router.dart';
import 'package:ct/core/enums/activities.dart';
import 'package:ct/core/models/ride.dart';
import 'package:ct/core/models/scoped/main.dart';
import 'package:ct/styles/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class RidesPage extends StatefulWidget {
  @override
  _RidesPageState createState() => _RidesPageState();
}

class _RidesPageState extends State<RidesPage> with TickerProviderStateMixin {
  ScrollController _scrollController = new ScrollController();
  AnimationController animationController;
  MainModel _model;
  List<RideModel> rides = [];
  String search = '';
  int rideCount = 0;

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
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
        _model = model;
        _getRides();
        return Container(
          color: AppTheme.background,
          child: Scaffold(
            backgroundColor: AppTheme.background,
            body: _buildBody(),
          ),
        );
      },
    );
  }

  void _getRides() {
    if (search.length <= 0) {
      rides = _model.rides;
    }
    if (_model.rideFilter != null && _model.rideFilter.isSelected) {
      if (_model.rideFilter.isFavourite) {
        rides = _model.rides.where((ride) => ride.isFavourite).toList();
      }
      if (_model.rideFilter.isToday) {
        var tdate = DateTime.now();
        rides = rides
            .where((ride) =>
                ride.createdDate.day == tdate.day &&
                ride.createdDate.month == tdate.month &&
                ride.createdDate.year == tdate.year)
            .toList();
      }

      if (_model.rideFilter.activity == Activities.running) {
        rides = rides.where((r) => r.activity == Activities.running).toList();
      } else if (_model.rideFilter.activity == Activities.cycling) {
        rides = rides.where((r) => r.activity == Activities.cycling).toList();
      }
    }
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
              child: rides.length == 0
                  ? _nodata()
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: rides.length,
                      padding: EdgeInsets.only(top: 8),
                      itemBuilder: (context, index) {
                        animationController.forward();
                        return RideView(
                            animationController: animationController,
                            animation: _calculateAnimation(index),
                            ride: rides[index]);
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _nodata() {
    return NoData(
      icon: Icons.directions_bike,
      description: 'Click on the + icon to add new ride.',
      message: 'No rides available.',
    );
  }

  Animation<double> _calculateAnimation(int index) {
    var count = rides.length > 10 ? 10 : rides.length;
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
                      '${rides.length} rides found',
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
                      Navigator.pushNamed(context, Router.rideFilter);
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
                      hintText: "rides to",
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
        rides =
            _model.rides.where((ride) => ride.rideTo.contains(search)).toList();
      } else {
        rides = _model.rides;
      }
    });
  }

  Widget getAppBarUI() {
    return SubTitleBar(
      isPopup: false,
      title: 'Explore All Rides',
      onTap: () {
        Navigator.pushNamed(context, Router.addRide);
      },
    );
  }
}
