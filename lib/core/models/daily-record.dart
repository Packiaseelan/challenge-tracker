class DailyRecordModel {
  int _id;
  String _rideTo;
  DateTime _createdDate;
  DateTime _modifiedDate;
  double _kmCovered;

  DailyRecordModel(
    this._id,
    this._rideTo,
    this._kmCovered,
    this._createdDate,
    this._modifiedDate,
  );

  int get id => _id;
  String get rideTo => _rideTo;
  DateTime get createdDate => _createdDate;
  DateTime get modifiedDate => _modifiedDate;
  double get kmCovered => _kmCovered;

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

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null && id != 0) {
      map['id'] = id;
    }
    map['rideTo'] = rideTo;
    map['createdDate'] = createdDate.millisecondsSinceEpoch;
    map['modifiedDate'] = modifiedDate.millisecondsSinceEpoch;
    map['kmCovered'] = kmCovered;
    return map;
  }

  DailyRecordModel.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._rideTo = map['rideTo'];
    this._createdDate = DateTime.fromMillisecondsSinceEpoch(map['createdDate']);
    this._modifiedDate =
        DateTime.fromMillisecondsSinceEpoch(map['modifiedDate']);
    this._kmCovered = map['kmCovered'];
  }
}
