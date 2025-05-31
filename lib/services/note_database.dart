import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NoteDatabase {
  static const _dbName = 'notes.db';
  static const _dbVersion = 2;
  static const _tableName = 'notes';

  static final NoteDatabase instance = NoteDatabase._init();

  static Database? _database;

  NoteDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _openDB();
    return _database!;
  }

  Future<Database> _openDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        isPinned INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
          'ALTER TABLE $_tableName ADD COLUMN isPinned INTEGER NOT NULL DEFAULT 0');
    }
  }
}
