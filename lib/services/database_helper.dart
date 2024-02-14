
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

  static Future<double> getsum(String type) async {
    final db = await _getDB();
    double totalDistance = 0.0;
    double totalLiter = 0.0;
    double totalExpense = 0.0;

    if (type == 'Distance') {
      List<Map<String, dynamic>> result = await db
          .rawQuery('SELECT SUM(distance) as totalDistance FROM record');
      totalDistance = result.first['totalDistance'] ?? 0.0;
      return totalDistance;
    } else if (type == 'Liter') {
      List<Map<String, dynamic>> result =
          await db.rawQuery('SELECT SUM(liter) as totalLiter FROM record');
      totalLiter = result.first['totalLiter'] ?? 0.0;
      return totalLiter;
    } else if (type == 'Money') {
      List<Map<String, dynamic>> result =
          await db.rawQuery('SELECT SUM(baht) as totalExpense FROM record');
      totalExpense = result.first['totalExpense'] ?? 0.0;
      return totalExpense;
    } else if (type == 'BpL') {
      double money = await getsum('Money');
      double liter = await getsum('Liter');
      return liter != 0 ? money / liter : 0.0;
    } else if (type == 'BpD') {
      double money = await getsum('Money');
      double distance = await getsum('Distance');
      return distance != 0 ? money / distance : 0.0;
    } else {
      return 0.0;
    }
  }

// add
  static Future<int> addRecord(Record record) async {
    final db = await _getDB();
    return await db.insert("record", record.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // static Future<int> addCar(Car car) async {
  //   final db = await _getDB();
  //   return await db.insert("car", car.toJson(),
  //       conflictAlgorithm: ConflictAlgorithm.replace);
  // }

// update
  static Future<int> updateRecord(Record record) async {
    final db = await _getDB();
    return await db.update("record", record.toJson(),
        where: 'id = ?',
        whereArgs: [record.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // delete
  static Future<int> deleteRecord(Record record) async {
    final db = await _getDB();
    return await db.delete(
      "record",
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  static Future<List<Record>?>? getAllRecord() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("Record");

    if (maps.isEmpty) {
      return null;
    }
    return List.generate(maps.length, (index) => Record.fromJson(maps[index]));
  }
}
