import 'dart:io';
import 'package:path/path.dart';
import 'package:design_api_database/src/models/alarms_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;
    // If database don't exists, create one
    _database = await init();
    return _database;
  }

  // Create the database and the Employee table
  Future<Database> init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'alarmsTable.db');

    return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Alarm('
          'alarm_id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'alarm_time TEXT,'
          'alarm_status TEXT,'
          'alarm_repeat TEXT'
          ')');
    });
  }

  Future<int> addAlarm(Alarm item) async {
    //returns number of items inserted as an integer

    final db = await init(); //open database
    return db.insert("Alarm", item.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int> updateAlarm(int id, Alarm item) async {
    // returns the number of rows updated

    final db = await init();

    int result = await db.update("Alarm", item.toMap(), where: "alarm_id = ?", whereArgs: [id]);
    return result;
  }

  createAlarm(Alarm item) async {
    final db = await database;
    final res = await db.insert('Alarm', item.toMap());

    return res;
  }

  Future<int> deleteAllAlarms() async {
    final db = await database;
    final res = await db.delete('Alarm');
    return res;
  }

  Future<int> deleteAlarm(int id) async {
    //returns number of items deleted
    final db = await init();

    int result = await db.delete("Alarm", where: "alarm_id = ?", whereArgs: [id]);

    return result;
  }

  Future<List<Alarm>> fetchAlarms() async {
    //returns the memos as a list (array)

    final db = await init();
    final maps = await db.query("Alarm"); //query all the rows in a table as an array of maps

    return List.generate(maps.length, (i) {
      //create a list of memos
      return Alarm(
        idAlarm: maps[i]['alarm_id'],
        timeAlarm: maps[i]['alarm_time'],
        statusAlarm: maps[i]['alarm_status'],
        repeatAlarm: maps[i]['alarm_repeat'],
      );
    });
  }

/*
  Future<List<Alarm>> getAllAlarms() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Alarm");

    print(res);

    List<Alarm> list = res.isNotEmpty ? res.map((c) => Alarm.fromJson(c)).toList() : [];

    return list;
  }
  */
}
