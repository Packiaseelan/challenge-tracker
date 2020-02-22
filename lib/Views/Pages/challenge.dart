import 'package:ct/Views/components/app_button.dart';
import 'package:ct/Views/components/calendar/calendar_popup_view.dart';
import 'package:ct/Views/components/sub_title_bar.dart';
import 'package:ct/core/enums/activities.dart';
import 'package:ct/core/models/challenge.dart';
import 'package:ct/core/models/scoped/main.dart';
import 'package:ct/styles/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ChallengePage extends StatefulWidget {
  @override
  _ChallengePageState createState() => _ChallengePageState();
}

bool _isLoad = false;

class _ChallengePageState extends State<ChallengePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  MainModel main;
  static DateTime now = DateTime.now();
  DateTime startDate = DateTime(now.year, now.month, now.day);
  DateTime endDate = DateTime(now.year, now.month, now.day);
  int durationInDays = 0;
  double remainingAverage = 0;
  double target = 0;
  double initial = 0;
  String challengeName;
  String route;

  Activities _activity;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      main = model;
      _updateSelectedChallengeDetails();
      return Container(
        color: AppTheme.background,
        child: Scaffold(
          backgroundColor: AppTheme.background,
          body: Column(
            children: <Widget>[
              getAppBarUI(),
              Expanded(
                child: _buildEditableForm(),
              ),
              Divider(
                height: 1,
              ),
              AppButton(
                title: 'Save',
                onPressed: onSave,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildEditableForm() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            _buildTextField('Challenge name', false),
            _buildDatePicker(),
            _buildActivityPicker(),
            _buildTextField('Target', true),
            _buildTextField('Initial', true),
            _buildRemainimg(),
          ],
        ),
      ),
    );
  }

  Widget _buildRemainimg() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'Durstion in Days: $durationInDays',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            'Remaining Average: ${remainingAverage.toStringAsFixed(2)} km(s) per day.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Row(
          children: <Widget>[
            Text('Duration'),
            SizedBox(
              width: 20,
            ),
            Text(
              'From',
              style: TextStyle(color: Colors.grey),
            ),
            FlatButton(
              onPressed: () => showDemoDialog(context: context),
              child: Text(
                '${startDate.day}-${startDate.month}-${startDate.year}',
              ),
            ),
            Text(
              'To',
              style: TextStyle(color: Colors.grey),
            ),
            FlatButton(
              onPressed: () => showDemoDialog(context: context),
              child: Text(
                '${endDate.day}-${endDate.month}-${endDate.year}',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityPicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Row(
          children: <Widget>[
            Text('Activity'),
            SizedBox(
              width: 20,
            ),
            FlatButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  _activity = Activities.running;
                });
              },
              child: Icon(
                Icons.directions_run,
                size: _activity == Activities.running ? 45 : 40,
                color: _activity == Activities.running
                    ? AppTheme.primaryColor
                    : Colors.grey,
              ),
            ),
            FlatButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  _activity = Activities.cycling;
                });
              },
              child: Icon(
                Icons.directions_bike,
                size: _activity == Activities.cycling ? 45 : 40,
                color: _activity == Activities.cycling
                    ? AppTheme.primaryColor
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String text, bool isNumeric) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        onChanged: (txt) {
          textChanged(txt, text);
        },
        validator: (txt) {
          if (txt.isEmpty)
            return '$text is required.';
          else
            return null;
        },
        onSaved: (txt) {
          textChanged(txt, text);
        },
        initialValue: _getInitialValue(text),
        keyboardType: isNumeric
            ? TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Enter $text',
          labelText: '$text',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  void onSave() {
    if (!_formKey.currentState.validate()) return;
    if (_activity == Activities.none) return;
    _formKey.currentState.save();
    int id = main.selectedChallenge == null ? 0 : main.selectedChallenge.id;
    var model = ChallengeModel(id, challengeName, DateTime.now(), startDate,
        endDate, target, initial, false, _activity);

    main.saveChallenge(model);
    Navigator.pop(context);
  }

  void textChanged(String value, String text) {
    switch (text) {
      case 'Challenge name':
        challengeName = value;
        break;
      case 'Target':
        target = double.parse(value);
        calculateAverage();
        break;
      case 'Initial':
        initial = double.parse(value);
        calculateAverage();
        break;
    }
  }

  String _getInitialValue(String text) {
    if (main.selectedChallenge == null) return '';
    switch (text) {
      case 'Challenge name':
        return main.selectedChallenge.challengeName;
      case 'Target':
        return main.selectedChallenge.target.toString();
      case 'Initial':
        return main.selectedChallenge.initial.toString();
      default:
        return '';
    }
  }

  void calculateAverage() {
    setState(() {
      remainingAverage = (target - initial) / durationInDays.round();
    });
  }

  void _updateSelectedChallengeDetails() {
    if (main.selectedChallenge != null) {
      if (!_isLoad) {
        challengeName = main.selectedChallenge.challengeName;
        startDate = main.selectedChallenge.startDate;
        endDate = main.selectedChallenge.endDate;
        target = main.selectedChallenge.target;
        initial = main.selectedChallenge.initial;
        _activity = main.selectedChallenge.activity;
        remainingAverage = (target - initial) / durationInDays.round();
        _isLoad = true;
      }
    }
  }

  Widget getAppBarUI() {
    return SubTitleBar(
      isPopup: true,
      title: 'Challenge Details',
      onTap: () {},
    );
  }

  void showDemoDialog({BuildContext context}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            if (startData != null && endData != null) {
              startDate = startData;
              endDate = endData;
              durationInDays = endDate.difference(startDate).inDays + 1;
              remainingAverage = (target - initial) / durationInDays.round();
            }
          });
        },
        onCancelClick: () {},
      ),
    );
  }
}
