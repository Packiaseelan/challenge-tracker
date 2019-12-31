class DetailsModel {
  int _id;
  String _firstName;
  String _lastName;
  String _dOB;
  double _weight;
  double _height;

  DetailsModel(
    this._id,
    this._firstName,
    this._lastName,
    this._dOB,
    this._weight,
    this._height,
  );

  int get id => _id;

  String get firstName => _firstName;

  String get lastName => _lastName;

  String get dOB => _dOB;

  double get weight => _weight;

  double get height => _height;

  set id(int newId) {
    this._id = newId;
  }

  set firstName(String fname) {
    this._firstName = fname;
  }

  set lastName(String lname) {
    this._lastName = lname;
  }

  set dOB(String dob) {
    this._dOB = dob;
  }

  set weight(double weight) {
    this._weight = weight;
  }

  set height(double height) {
    this._height = height;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['dateOfBirth'] = _dOB;
    map['weight'] = _weight;
    map['height'] = _height;
    return map;
  }

  DetailsModel.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._firstName = map['firstName'];
    this._lastName = map['lastName'];
    this._dOB = map['dateOfBirth'];
    this._weight = map['weight'];
    this._height = map['height'];
  }
}
