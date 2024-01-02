import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fuelfill/models/model_Data.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbname = 'record.db';

  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbname),
      onCreate: (db, version) async {
        // Create the 'record' table
        await db.execute('''
          CREATE TABLE record (
            id INTEGER PRIMARY KEY,
            liter REAL NOT NULL,
            distance REAL NOT NULL,
            baht REAL NOT NULL,
            datetime TEXT NOT NULL
          )
        ''');

        // Create the 'car' table
        await db.execute('''
          CREATE TABLE car (
            name TEXT PRIMARY KEY,
            oiltype TEXT NOT NULL,
            miles REAL NOT NULL
          )
        ''');
      },
      version: _version,
    );
  }

// add
  static Future<int> addRecord(Record record) async {
    final db = await _getDB();
    return await db.insert("record", record.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> addCar(Car car) async {
    final db = await _getDB();
    return await db.insert("car", car.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

//update
  // static Future<int> updateRecord(Record record) async {
  //   final db = await _getDB();
  //   return await db.update("record", record.toJson(),
  //       where: 'id = ?',
  //       whereArgs: [record.id],
  //       conflictAlgorithm: ConflictAlgorithm.replace);
  // }

  // delete
  // static Future<int> deleteRecord(Record record) async {
  //   final db = await _getDB();
  //   return await db.delete(
  //     "record",
  //     where: 'id = ?',
  //     whereArgs: [record.id],
  //   );
  // }

  static Future<List<Record>?>? getAllRecord() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("Record");

    if(maps.isEmpty){
      return null;
    }return List.generate(maps.length, (index) => Record.fromJson(maps[index]));
  }
}
