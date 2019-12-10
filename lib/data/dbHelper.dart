import 'package:ct/core/models/challenge.dart';
import 'package:ct/core/models/details.dart';
import 'package:ct/core/models/ride.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:async';
import 'dart:io' as io;

class DBHelper {
  static DBHelper _dbHelper;
  static Database _database;
  DBHelper._internal();

  factory DBHelper() {
    if (_dbHelper == null) {
      _dbHelper = DBHelper._internal();
    }
    return _dbHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDatabase();
    }
    return _database;
  }

  Future<Database> initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'myfav.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE Challenges(
        id INTEGER PRIMARY KEY,
        challengeName TEXT,
        createdDate INT,
        modifiedDate INT,
        startDate INT,
        endDate INT,
        target DOUBLE,
        initial DOUBLE
      )
      ''');
    await db.execute('''
    CREATE TABLE Rides(
      id INTEGER PRIMARY KEY,
      rideTo TEXT,
      kmCovered DOUBLE,
      createdDate INT,
      modifiedDate INT,
      isFavourite BIT
    )
    ''');
    await db.execute('''
      CREATE TABLE Details(
        id INTEGER PRIMARY KEY,
        firstName TEXT,
        lastName TEXT,
        dateOfBirth TEXT,
        weight DOUBLE,
        height DOUBLE,
        date TEXT
      )
      ''');
  }

  Future<int> insertDetails(Map<String, dynamic> map) async {
    Database db = await this.database;
    map['date'] = DateTime.now().millisecondsSinceEpoch;
    return db.insert('Details', map);
  }

  Future<int> insertChallenges(Map<String, dynamic> map) async {
    Database db = await this.database;
    return db.insert('Challenges', map);
  }

  Future<int> insertRide(Map<String, dynamic> map) async {
    Database db = await this.database;
    return db.insert('Rides', map);
  }

  //Updateoperation: Update object and save into the database.
  Future<int> updateDetails(Map<String, dynamic> map) async {
    Database db = await this.database;
    map['date'] = DateTime.now().millisecondsSinceEpoch;
    var result =
        db.update('Details', map, where: 'id = ?', whereArgs: [map['id']]);
    return result;
  }

  Future<int> updateChallenges(Map<String, dynamic> map) async {
    Database db = await this.database;
    map['modifiedDate'] = DateTime.now().millisecondsSinceEpoch;
    var result =
        db.update('Challenges', map, where: 'id = ?', whereArgs: [map['id']]);
    return result;
  }

  Future<int> updateRide(Map<String, dynamic> map) async {
    Database db = await this.database;
    map['modifiedDate'] = DateTime.now().millisecondsSinceEpoch;
    var result =
        db.update('Rides', map, where: 'id = ?', whereArgs: [map['id']]);
    return result;
  }

  //Fetch operations:
  Future<List<Map<String, dynamic>>> _getDetails() async {
    Database db = await this.database;
    return db.query('Details', where: 'id = 1');
  }

  Future<List<Map<String, dynamic>>> _getChallenges() async {
    Database db = await this.database;
    return db.query('Challenges');
  }

  Future<List<Map<String, dynamic>>> _getDailyRecords() async {
    Database db = await this.database;
    return db.query('Rides');
  }

  Future<DetailsModel> getDetails() async {
    var getDetails = _getDetails();
    var data = await getDetails;
    if (data != null && data.length > 0)
      return DetailsModel.fromMap(data[0]);
    else
      return null;
  }

  Future<List<ChallengeModel>> getChallenges() async {
    var challenges = _getChallenges();
    var data = await challenges;
    List<ChallengeModel> c = List<ChallengeModel>();
    for (int i = 0; i < data.length; i++) {
      c.add(ChallengeModel.fromMap(data[i]));
    }
    return c;
  }

  Future<List<RideModel>> getDailyRecords() async {
    var dailyRecords = _getDailyRecords();
    var data = await dailyRecords;
    List<RideModel> daily = List<RideModel>();
    for (int i = 0; i < data.length; i++) {
      daily.add(RideModel.fromMap(data[i]));
    }
    return daily;
  }
}
