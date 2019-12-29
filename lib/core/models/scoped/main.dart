import 'package:ct/core/models/challenge.dart';
import 'package:ct/core/models/details.dart';
import 'package:ct/core/models/ride.dart';
import 'package:ct/core/models/ride_filter.dart';
import 'package:ct/data/dbHelper.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model {
  DBHelper _dbHelper = DBHelper();

  DetailsModel detailsModel;
  List<ChallengeModel> challenges = [];
  List<ChallengeModel> activeChallenges = [];
  List<RideModel> rides = [];
  List<RideModel> todayRides = [];
  ChallengeModel selectedChallenge;
  RideFilterModel rideFilter;

  int currentHomePage;

  void init() {
    currentHomePage = 1;
    notifyListeners();
    _getDetails();
    _getChallenges();
    _getDailyRecords();
  }

  void _getDetails() async {
    _dbHelper.getDetails().then((details) {
      detailsModel = details;
      notifyListeners();
    });
  }

  void _getChallenges() async {
    _dbHelper.getChallenges().then((challenge) {
      challenges = challenge;
      notifyListeners();
    });
  }

  void _getDailyRecords() async {
    _dbHelper.getDailyRecords().then((daily) {
      daily.sort((b, a) => a.createdDate.compareTo(b.createdDate));
      rides = daily;
      notifyListeners();
      _getTodayRides();
    });
  }

  void _getTodayRides() {
    if (rides.length > 0) {
      var tdate = DateTime.now();
      todayRides = rides
          .where((ride) =>
              ride.createdDate.day == tdate.day &&
              ride.createdDate.month == tdate.month &&
              ride.createdDate.year == tdate.year)
          .toList();
      notifyListeners();
    }
  }

  void saveDetails(DetailsModel details) {
    detailsModel = details;
    notifyListeners();
    if (details.id == 0 || details.id == null)
      _dbHelper.insertDetails(details.toMap());
    else
      _dbHelper.updateDetails(details.toMap());
  }

  void saveChallenge(ChallengeModel model) {
    if (model.id == 0 || model.id == null) {
      challenges.add(model);
      notifyListeners();
      _dbHelper.insertChallenges(model.toMap());
    } else {
      challenges.where((d) => d.id == model.id).toList()[0] = model;
      _dbHelper.updateChallenges(model.toMap());
    }
  }

  void saveRideRecords(RideModel model) {
    if (model.rideTo.isEmpty) return;
    rides.add(model);
    notifyListeners();
    _getTodayRides();
    if (model.id == 0 || model.id == null)
      _dbHelper.insertRide(model.toMap());
    else
      _dbHelper.updateRide(model.toMap());
  }

  void updateRideRecords(RideModel model) {
    rides.where((r) => r.id == model.id).toList()[0] = model;
    notifyListeners();
    _dbHelper.updateRide(model.toMap());
  }

  void onSetHomePage(int index) {
    currentHomePage = index;
    notifyListeners();
  }
}
