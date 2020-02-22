import 'package:ct/core/enums/activities.dart';
import 'package:intl/intl.dart';

class ChallengeModel {
  int _id;
  String _challengeName;
  DateTime _createdDate;
  DateTime _startDate;
  DateTime _endDate;
  double _target;
  double _initial;
  bool _isFavourite;
  Activities _activity;

  ChallengeModel(
      this._id,
      this._challengeName,
      this._createdDate,
      this._startDate,
      this._endDate,
      this._target,
      this._initial,
      this._isFavourite,
      this._activity);

  int get id => _id;
  String get challengeName => _challengeName;
  DateTime get createdDate => _createdDate;
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  double get target => _target;
  double get initial => _initial;
  bool get isFavourite => _isFavourite;
  Activities get activity => _activity;

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

  set isFavourite(bool fav) {
    this._isFavourite = fav;
  }

  set activity(Activities act) {
    this._activity = act;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null && id != 0) {
      map['id'] = id;
    }
    map['challengeName'] = _challengeName;
    map['createdDate'] = _createdDate.millisecondsSinceEpoch;
    map['startDate'] = _startDate.millisecondsSinceEpoch;
    map['endDate'] = _endDate.millisecondsSinceEpoch;
    map['target'] = _target;
    map['initial'] = _initial;
    map['isFavourite'] = _isFavourite ? 1 : 0;
    map['activity'] = _activity.index;
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
    this._isFavourite = map['isFavourite'] == 1;
    this._activity = Activities.values[map['activity']];
  }

  int getDuration() {
    return _endDate.difference(_startDate).inDays + 1;
  }

  String getDurationToString() {
    return '${DateFormat("dd MMM").format(_startDate)} - ${DateFormat("dd MMM").format(_endDate)}';
  }

  bool isCompleted() {
    var date = DateTime.now();
    if (_endDate.isBefore(date)) {
      return true;
    }
    return false;
  }
}
