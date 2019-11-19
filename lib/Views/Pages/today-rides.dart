import 'package:ct/Views/components/header.dart';
import 'package:ct/Views/components/nodata.dart';
import 'package:ct/Views/router.dart';
import 'package:ct/core/models/daily-record.dart';
import 'package:ct/core/models/scoped/main.dart';
import 'package:ct/utils/converter.dart';
import 'package:ct/utils/ui-helper.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class TodayRidesPage extends StatefulWidget {
  @override
  _TodayRidesPageState createState() => _TodayRidesPageState();
}

class _TodayRidesPageState extends State<TodayRidesPage> {
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
        HeaderView(
          title: 'Today\'s Ride',
          leftIcon: Icons.arrow_back_ios,
          onLeftPressed: () => Navigator.of(context).pop(),
          rightIcon: Icons.add,
          onRightPressed: () =>
              Navigator.pushNamed(context, Router.dailyRecord),
        ),
        _buildTodayDistance(),
        Container(
          height: UIHelper.safeAreaHeight - 200,
          child: main.todayRides.length > 0
              ? _buildList(main.todayRides)
              : _noData(),
        ),
      ],
    );
  }

  Widget _buildTodayDistance() {
    if (main.todayRides.length <= 0) return SizedBox();
    double kms = 0;
    main.todayRides.forEach((f) => kms += f.kmCovered);
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Text(
            'Today distance covered',
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          Text(
            ' ${kms.toString()}',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<DailyRecordModel> model) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
            onTap: () {
              //_onItemTapped(model[index], index);
            },
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.directions_bike,
                    color: Colors.grey,
                  ),
                  title: Text(('To: ${model[index].rideTo}' ?? '')),
                  subtitle: Text('${dts(model[index].createdDate)}'),
                  trailing:
                      Text('Km :${model[index].kmCovered.toString()}' ?? ''),
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
      icon: Icons.directions_bike,
      message: 'No rides available today.',
      description: 'Click on the + icon to add ride details.',
    );
  }
}
