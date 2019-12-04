import 'package:ct/Views/components/alert.dart';
import 'package:ct/Views/router.dart';
import 'package:ct/core/models/scoped/main.dart';
import 'package:ct/utils/app-colors.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(color: headerColor),
                      currentAccountPicture: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 80,
                      ),
                      accountEmail: Text(
                        'admin@riders.com',
                      ),
                      accountName: Text(
                        '${model.detailsModel.firstName} ${model.detailsModel.lastName}',
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.home),
                      title: Text('Home'),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.track_changes),
                      title: Text('Callenges'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, Router.challenges);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.directions_bike),
                      title: Text('All Rides'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, Router.rides);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.add),
                      title: Text('Add New Ride'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, Router.addRide);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.directions_bike),
                      title: Text('Today Rides'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, Router.todayRides);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Profile'),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, Router.profile);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                      onTap: () {
                        Navigator.of(context).pop();
                        // Navigator.pushNamed(context, addRides);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.assessment),
                      title: Text('Reports'),
                      onTap: () {
                        Navigator.of(context).pop();
                        //  Navigator.pushNamed(context, addRides);
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Exit'),
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) => BeautifulAlertDialog(
                      child: Icon(
                        Icons.exit_to_app,
                        size: 50,
                        color: Colors.red,
                      ),
                      title: 'Are you sure?',
                      message: 'Do you  want to exit an App?',
                      acceptText: 'Exit',
                      discardText: 'Cancel',
                      onAcceptPressed: () => Navigator.of(context).pop(true),
                      onDiscardPressed: () => Navigator.of(context).pop(false),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
