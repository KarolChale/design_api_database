import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:async';
import 'package:design_api_database/src/models/task_model.dart';

class TaskDbProvider {
  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory(); //returns a directory which stores permanent files
    final path = join(directory.path, "tasks.db"); //create path to database

    return await openDatabase(
        //open the database or create a database if there isn't any
        path,
        version: 1, onCreate: (Database db, int version) async {
      await db.execute("""
          CREATE TABLE Tasks(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          description TEXT,
          date TEXT,
		  time TEXT,
		  status INTEGER)""");
    });
  }

  Future<int> addItem(Tasks item) async {
    //returns number of items inserted as an integer

    final db = await init(); //open database

    return db.insert(
      "Tasks", item.toMap(), //toMap() function from MemoModel
      conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  Future<List<Tasks>> fetchMemos() async {
    //returns the memos as a list (array)

    final db = await init();
    final maps = await db.query("Tasks"); //query all the rows in a table as an array of maps

    return List.generate(maps.length, (i) {
      //create a list of memos
      return Tasks(
        task_id: maps[i]['id'],
        task_desc: maps[i]['description'],
        task_date: maps[i]['date'],
        task_time: maps[i]['time'],
        task_status: maps[i]['status'],
      );
    });
  }

  Future<int> deleteMemo(int id) async {
    //returns number of items deleted
    final db = await init();

    int result = await db.delete("Tasks", where: "id = ?", whereArgs: [id]);

    return result;
  }

  Future<int> updateMemo(int id, Tasks item) async {
    // returns the number of rows updated

    final db = await init();

    int result = await db.update("Tasks", item.toMap(), where: "id = ?", whereArgs: [id]);
    return result;
  }
}
