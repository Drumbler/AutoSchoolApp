import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'DB.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE IF NOT EXISTS teachers (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              pass_hash TEXT
            )
          ''');
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getAllTeachers() async {
    final db = await database;
    return await db.query('teachers', columns: ['id', 'name']);
  }

  static Future<String> getTeacherName(int teacherId) async {
    final db = await database;
    final result = await db.query(
      'teachers',
      columns: ['name'],
      where: 'id = ?',
      whereArgs: [teacherId],
    );
    if (result.isNotEmpty) {
      return result.first['name'] as String;
    } else {
      return 'Unknown Teacher';
    }
  }
}
