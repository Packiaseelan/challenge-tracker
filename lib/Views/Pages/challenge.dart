import 'package:ct/Views/components/app_button.dart';
import 'package:ct/Views/components/sub_title_bar.dart';
import 'package:ct/core/models/challenge.dart';
import 'package:ct/core/models/scoped/main.dart';
import 'package:ct/styles/appTheme.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ChallengePage extends StatefulWidget {
  @override
  _ChallengePageState createState() => _ChallengePageState();
}

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
                child: SingleChildScrollView(
                  child: _buildEditableForm(),
                ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTextField('Challenge name', false),
            _buildStartDatePicker(),
            _buildEndDatePicker(),
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

  Widget _buildStartDatePicker() {
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
            Text('Start Date'),
            FlatButton(
              onPressed: () => _selectStartDate(),
              child: Text(
                '${startDate.day}-${startDate.month}-${startDate.year}',
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

  Widget _buildEndDatePicker() {
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
            Text('End Date'),
            FlatButton(
              onPressed: () => _selectEndDate(),
              child: Text(
                '${endDate.day}-${endDate.month}-${endDate.year}',
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

  Future<Null> _selectStartDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != startDate)
      setState(() {
        startDate = picked;
        durationInDays = endDate.difference(startDate).inDays + 1;
      });
  }

  Future<Null> _selectEndDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: endDate,
        firstDate: startDate,
        lastDate: DateTime(2101));
    if (picked != null && picked != endDate)
      setState(() {
        endDate = picked;
        durationInDays = endDate.difference(startDate).inDays + 1;
      });
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
        onSaved: (txt){
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
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    int id = main.selectedChallenge == null ? 0 : main.selectedChallenge.id;
    var model = ChallengeModel(
      id,
      challengeName,
      DateTime.now(),
      startDate,
      endDate,
      target,
      initial,
    );

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
      challengeName = main.selectedChallenge.challengeName;
      startDate = main.selectedChallenge.startDate;
      endDate = main.selectedChallenge.endDate;
      target = main.selectedChallenge.target;
      initial = main.selectedChallenge.initial;
      remainingAverage = (target - initial) / durationInDays.round();
    }
  }

  Widget getAppBarUI() {
    return SubTitleBar(
      isPopup: true,
      title: 'Challenge Details',
      onTap: () {},
    );
  }
}
