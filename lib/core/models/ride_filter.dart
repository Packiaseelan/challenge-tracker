class RideFilterModel {
  bool _isFavourite;
  bool _isSelected;
  bool _isToday;
  DateTime _from;
  DateTime _to;

  RideFilterModel(this._isFavourite, this._isSelected);

  bool get isFavourite => _isFavourite;
  bool get isSelected => _isSelected;
  bool get isToday => _isToday;
  DateTime get from => _from;
  DateTime get to => _to;

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

  RideFilterModel.reset() {
    this._isFavourite = false;
    this._isSelected = false;
    this._isToday = false;
  }
}
