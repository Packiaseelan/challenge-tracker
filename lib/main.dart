import 'package:ct/Views/router.dart';
import 'package:ct/core/models/scoped/main.dart';
import 'package:ct/styles/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppTheme.primaryColor,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    MainModel mainModel = MainModel();
    mainModel.init();
    return ScopedModel<MainModel>(
      model: mainModel,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Challenge Tracker',
        theme: AppTheme.buildLightTheme(),
        initialRoute: Router.initialRoute,
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
