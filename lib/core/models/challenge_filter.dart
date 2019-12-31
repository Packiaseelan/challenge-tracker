class ChallengeFilterModel {
  bool _isFavourite;
  bool _isSelected;

  ChallengeFilterModel(
    this._isFavourite,
    this._isSelected,
  );

  bool get isFavourite => _isFavourite;
  bool get isSelected => _isSelected;

  set isFavourite(bool isFav) {
    this._isFavourite = isFav;
  }

  set isSelected(bool selected) {
    this._isSelected = selected;
  }

  ChallengeFilterModel.reset() {
    this._isFavourite = false;
    this._isSelected = false;
  }
}
