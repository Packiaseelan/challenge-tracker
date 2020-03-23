import 'package:ct/Views/components/app_button.dart';
import 'package:ct/Views/components/sub_title_bar.dart';
import 'package:ct/core/enums/activities.dart';
import 'package:ct/core/models/ride.dart';
import 'package:ct/core/models/scoped/main.dart';
import 'package:ct/styles/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class AddNewRidesPage extends StatefulWidget {
  @override
  _AddNewRidesPageState createState() => _AddNewRidesPageState();
}

class _AddNewRidesPageState extends State<AddNewRidesPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static DateTime now = DateTime.now();
  DateTime selectedDate = DateTime(now.year, now.month, now.day);
  String rideTo;
  double kmCovered;
  MainModel main;
  Activities _activity = Activities.none;
  bool _buttonClicked = false;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        main = model;
        return Container(
          color: AppTheme.background,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: <Widget>[
                getAppBarUI(),
                Expanded(
                  child: _buildForm(),
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
      },
    );
  }

  void onSave() {
    setState(() {
      _buttonClicked = true;
    });
    if (!_formKey.currentState.validate()) return;
    print(_activity);
    if (_activity == Activities.none) return;
    _formKey.currentState.save();

    var model = RideModel(
      0,
      rideTo,
      kmCovered,
      selectedDate,
      DateTime.now(),
      false,
      _activity,
    );
    main.saveRideRecords(model);
    Navigator.pop(context);
  }

  Widget _buildForm() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            _buildTextField('Ride to', false),
            _buildTextField('Km covered', true),
            _buildDatePicker(),
            _buildActivityPicker(),
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
            Text(
              _buttonClicked && _activity == Activities.none
                  ? '* Activity Required'
                  : '',
              style: TextStyle(fontSize: 8, color: Colors.red),
            )
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

  void textChanged(String value, String text) {
    switch (text) {
      case 'Ride to':
        rideTo = value;
        break;
      case 'Km covered':
        kmCovered = double.parse(value);
        break;
    }
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
            Text('Date'),
            FlatButton(
              onPressed: () => _selectDate(context),
              child: Text(
                '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
              ),
            ),
            Text(
              'Format(dd-MM-yyyy)',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Widget getAppBarUI() {
    return SubTitleBar(
      isPopup: true,
      title: 'Add Ride Details',
      onTap: () {},
    );
  }
}

