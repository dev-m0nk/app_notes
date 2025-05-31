import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/note.dart';
import '../services/note_service.dart';

class NoteController extends GetxController {
  final NoteService _noteService;
  NoteController(this._noteService);

  RxList<Note> notes = <Note>[].obs;
  RxString searchQuery = ''.obs;
  RxString sortField = 'createdAt'.obs;
  Note? _lastDeletedNote;

  @override
  void onInit() {
    fetchNotes();
    super.onInit();
  }

  void fetchNotes() async {
    final allNotes = await _noteService.getNotes();
    notes.value = allNotes;
  }

  void addOrUpdateNote(Note note) async {
    if (note.id == null) {
      await _noteService.insertNote(note);
    } else {
      await _noteService.updateNote(note);
    }
    fetchNotes();
  }

  void deleteNote(Note note) {
    _lastDeletedNote = note;
    notes.remove(note);

    bool undoPressed = false;

    Get.snackbar(
      'Note Deleted',
      'Undo',
      duration: Duration(seconds: 5),
      mainButton: TextButton(
        onPressed: () {
          undoPressed = true;
          if (_lastDeletedNote != null) {
            notes.add(_lastDeletedNote!);
            addOrUpdateNote(_lastDeletedNote!);
            _lastDeletedNote = null;
            Get.back();
          }
        },
        child: Text('UNDO', style: TextStyle(color: Colors.yellow)),
      ),
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
    );

    Future.delayed(Duration(seconds: 5), () {
      if (!undoPressed && _lastDeletedNote != null) {
        _noteService.deleteNote(_lastDeletedNote!.id!);
        _lastDeletedNote = null;
      }
    });
  }

  List<Note> get filteredNotes {
    List<Note> filtered = notes.where((note) {
      final query = searchQuery.value.toLowerCase();
      return note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query) ||
          (note.category?.toLowerCase().contains(query) ?? false);
    }).toList();

    filtered.sort((a, b) {
      if (sortField.value == 'title') {
        return a.title.compareTo(b.title);
      } else {
        return b.createdAt.compareTo(a.createdAt);
      }
    });
    return filtered;
  }
}
