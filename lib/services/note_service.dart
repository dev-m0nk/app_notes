import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';

class NoteService {
  late Database db;

  Future<void> init() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'notes.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, createdAt TEXT, updatedAt TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<List<Note>> getNotes() async {
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  Future<void> insertNote(Note note) async {
    await db.insert('notes', note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateNote(Note note) async {
    await db
        .update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<void> deleteNote(int id) async {
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
