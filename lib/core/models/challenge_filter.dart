import 'package:ct/core/enums/activities.dart';
import 'package:ct/core/enums/challenge_status.dart';

class ChallengeFilterModel {
  bool _isFavourite;
  bool _isSelected;
  ChallengeStatus _status;
  Activities _activity;

  ChallengeFilterModel(
      this._isFavourite, this._isSelected, this._status, this._activity);

  bool get isFavourite => _isFavourite;
  bool get isSelected => _isSelected;
  ChallengeStatus get status => _status;
  Activities get activity => _activity;

  set isFavourite(bool isFav) {
    this._isFavourite = isFav;
  }

  set isSelected(bool selected) {
    this._isSelected = selected;
  }

  set status(ChallengeStatus s) {
    this._status = s;
  }

  set activity(Activities act) {
    this._activity = act;
  }

  ChallengeFilterModel.reset() {
    this._isFavourite = false;
    this._isSelected = false;
    this._status = ChallengeStatus.inProgress;
    this._activity = Activities.none;
  }
}
