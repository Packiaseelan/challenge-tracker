import 'package:ct/Views/components/header.dart';
import 'package:ct/core/models/challenge.dart';
import 'package:ct/core/models/scoped/main.dart';
import 'package:ct/utils/ui-helper.dart';
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
      return Scaffold(
        body: _buildBody(),
      );
    });
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        HeaderView(
          leftIcon: Icons.arrow_back_ios,
          onLeftPressed: () => Navigator.of(context).pop(),
          title: 'Challenge Details',
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: UIHelper.safeAreaHeight - 100,
            child: _buildEditableForm(),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableForm() {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          _buildTextField('Challenge name', false),
          _buildStartDatePicker(),
          _buildEndDatePicker(),
          _buildTextField('Target', true),
          _buildTextField('Initial', true),
          RaisedButton(
            child: Text('Save'),
            onPressed: onSave,
          ),
          _buildRemainimg(),
        ],
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
}
