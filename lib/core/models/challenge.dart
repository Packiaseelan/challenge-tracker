class ChallengeModel {
  int _id;
  String _challengeName;
  DateTime _createdDate;
  DateTime _startDate;
  DateTime _endDate;
  double _target;
  double _initial;

  ChallengeModel(
    this._id,
    this._challengeName,
    this._createdDate,
    this._startDate,
    this._endDate,
    this._target,
    this._initial,
  );

  int get id => _id;
  String get challengeName => _challengeName;
  DateTime get createdDate => _createdDate;
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  double get target => _target;
  double get initial => _initial;

  set id(int newId) {
    this._id = newId;
  }

  set challengeName(String cName) {
    this._challengeName = cName;
  }

  set createdDate(DateTime date) {
    this._createdDate = date;
  }

  set startDate(DateTime date) {
    this._startDate = date;
  }

  set endDate(DateTime date) {
    this._endDate = date;
  }

  set target(double newtarget) {
    this._target = newtarget;
  }

  set initial(double newInitial) {
    this._initial = newInitial;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null && id != 0) {
      map['id'] = id;
    }
    map['challengeName'] = challengeName;
    map['createdDate'] = createdDate.millisecondsSinceEpoch;
    map['startDate'] = startDate.millisecondsSinceEpoch;
    map['endDate'] = endDate.millisecondsSinceEpoch;
    map['target'] = target;
    map['initial'] = initial;
    return map;
  }

  ChallengeModel.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._challengeName = map['challengeName'];
    this._createdDate = DateTime.fromMillisecondsSinceEpoch(map['createdDate']);
    this._startDate = DateTime.fromMillisecondsSinceEpoch(map['startDate']);
    this._endDate = DateTime.fromMillisecondsSinceEpoch(map['endDate']);
    this._target = map['target'];
    this._initial = map['initial'];
  }
}
