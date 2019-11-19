import 'package:ct/Views/components/header.dart';
import 'package:ct/core/models/details.dart';
import 'package:ct/core/models/scoped/main.dart';
import 'package:ct/utils/converter.dart';
import 'package:ct/utils/ui-helper.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  MainModel main;
  DetailsModel details;
  String fname;
  String lname;
  double weight;
  double height;

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      main = model;
      details = main.detailsModel;
      return Scaffold(
        body: _buildBody(),
      );
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

  Widget _buildBody() {
    return Container(
      //padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          HeaderView(
            leftIcon: Icons.arrow_back_ios,
            onLeftPressed: () {
              Navigator.of(context).pop();
            },
            title: 'Fill the details',
          ),
          Expanded(
            child: Container(
              height: UIHelper.safeAreaHeight - 100,
              padding: const EdgeInsets.all(20.0),
              child: _buildEditableForm(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableForm() {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          _buildTextField('Firstname', false),
          _buildTextField('Lastname', false),
          _buildDatePicker(),
          _buildTextField('Weight', true),
          _buildTextField('Height', true),
          RaisedButton(
            child: Text('Save'),
            onPressed: onSave,
          ),
        ],
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
            Text('Date Of Birth'),
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

  void onSave() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    var map = Map<String, dynamic>();
    map['firstName'] = fname;
    map['lastName'] = lname;
    map['dateOfBirth'] = dateToString(selectedDate);
    map['weight'] = weight;
    map['height'] = height;

    var deta = DetailsModel.fromMap(map);

    main.saveDetails(deta);
    Navigator.pushReplacementNamed(context, '/home');
  }

  void textChanged(String value, String text) {
    switch (text) {
      case 'Firstname':
        fname = value;
        break;
      case 'Lastname':
        lname = value;
        break;
      case 'Weight':
        weight = double.parse(value);
        break;
      case 'Height':
        height = double.parse(value);
        break;
    }
  }
}
