import 'package:ct/Views/components/header.dart';
import 'package:ct/core/models/daily-record.dart';
import 'package:ct/core/models/scoped/main.dart';
import 'package:ct/utils/ui-helper.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class DailyRecordPage extends StatefulWidget {
  @override
  _DailyRecordPageState createState() => _DailyRecordPageState();
}

class _DailyRecordPageState extends State<DailyRecordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  String rideTo;
  double kmCovered;
  MainModel main;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        main = model;
        return Scaffold(
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        HeaderView(
          leftIcon: Icons.arrow_back_ios,
          onLeftPressed: () => Navigator.of(context).pop(),
          title: 'Add Ride Records',
        ),
        Expanded(
          child: Container(
            height: UIHelper.safeAreaHeight - 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: _buildForm(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          _buildTextField('Ride to', false),
          _buildTextField('Km covered', true),
          _buildDatePicker(),
          RaisedButton(
            child: Text('Save'),
            onPressed: onSave,
          ),
        ],
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

  void onSave() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    var model = DailyRecordModel(
      0,
      rideTo,
      kmCovered,
      selectedDate,
      DateTime.now(),
    );
    main.saveRideRecords(model);
    Navigator.pop(context);
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
}
