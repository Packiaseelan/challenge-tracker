import 'package:ct/core/enums/activities.dart';

class RideFilterModel {
  bool _isFavourite;
  bool _isSelected;
  bool _isToday;
  DateTime _from;
  DateTime _to;
  Activities _activity;

  RideFilterModel(this._isFavourite, this._isSelected, this._activity);

  bool get isFavourite => _isFavourite;
  bool get isSelected => _isSelected;
  bool get isToday => _isToday;
  DateTime get from => _from;
  DateTime get to => _to;
  Activities get activity => _activity;

  set isFavourite(bool isFav) {
    this._isFavourite = isFav;
  }

  set isSelected(bool selected) {
    this._isSelected = selected;
  }

  set isToday(bool today) {
    this._isToday = today;
  }

  set from(DateTime frm) {
    this._from = frm;
  }

  set to(DateTime t) {
    this._to = t;
  }

  set activity(Activities activities) {
    this._activity = activities;
  }

  RideFilterModel.reset() {
    this._isFavourite = false;
    this._isSelected = false;
    this._isToday = false;
    this._activity = Activities.none;
  }
}
