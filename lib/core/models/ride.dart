import 'package:ct/core/enums/activities.dart';

class RideModel {
  int _id;
  String _rideTo;
  DateTime _createdDate;
  DateTime _modifiedDate;
  double _kmCovered;
  bool _isFavourite;
  Activities _activity;

  RideModel(
    this._id,
    this._rideTo,
    this._kmCovered,
    this._createdDate,
    this._modifiedDate,
    this._isFavourite,
    this._activity,
  );

  int get id => _id;
  String get rideTo => _rideTo;
  DateTime get createdDate => _createdDate;
  DateTime get modifiedDate => _modifiedDate;
  double get kmCovered => _kmCovered;
  bool get isFavourite => _isFavourite;
  Activities get activity => _activity;

  set id(int newId) {
    this._id = newId;
  }

  set rideTo(String rideto) {
    this._rideTo = rideto;
  }

  set createdDate(DateTime cdt) {
    this._createdDate = cdt;
  }

  set modifiedDate(DateTime mdt) {
    this._modifiedDate = mdt;
  }

  set kmCovered(double km) {
    this._kmCovered = km;
  }

  set isFavourite(bool isfav) {
    this._isFavourite = isfav;
  }

  set activity(Activities activities) {
    this._activity = activities;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null && _id != 0) {
      map['id'] = _id;
    }
    map['rideTo'] = _rideTo;
    map['createdDate'] = _createdDate.millisecondsSinceEpoch;
    map['modifiedDate'] = _modifiedDate.millisecondsSinceEpoch;
    map['kmCovered'] = _kmCovered;
    map['isFavourite'] = _isFavourite ? 1 : 0;
    map['activity'] = _activity.index;
    return map;
  }

  RideModel.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._rideTo = map['rideTo'];
    this._createdDate = DateTime.fromMillisecondsSinceEpoch(map['createdDate']);
    this._modifiedDate =
        DateTime.fromMillisecondsSinceEpoch(map['modifiedDate']);
    this._kmCovered = map['kmCovered'];
    this._isFavourite = map['isFavourite'] == 1;
    this._activity = Activities.values[map['activity']];
  }
}
