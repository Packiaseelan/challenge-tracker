import 'package:ct/core/enums/challenge_status.dart';

class ChallengeFilterModel {
  bool _isFavourite;
  bool _isSelected;
  ChallengeStatus _status;

  ChallengeFilterModel(
    this._isFavourite,
    this._isSelected,
    this._status,
  );

  bool get isFavourite => _isFavourite;
  bool get isSelected => _isSelected;
  ChallengeStatus get status => _status;

  set isFavourite(bool isFav) {
    this._isFavourite = isFav;
  }

  set isSelected(bool selected) {
    this._isSelected = selected;
  }

  set status(ChallengeStatus s){
    this._status = s;
  }

  ChallengeFilterModel.reset() {
    this._isFavourite = false;
    this._isSelected = false;
    this._status = ChallengeStatus.none;
  }
}
