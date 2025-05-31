import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/note_controller.dart';
import '../models/note.dart';

class NoteFormView extends StatefulWidget {
  const NoteFormView({super.key});

  @override
  State<NoteFormView> createState() => _NoteFormViewState();
}

class _NoteFormViewState extends State<NoteFormView> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final categoryController = TextEditingController(); // New controller
  final NoteController controller = Get.find();

  Note? editingNote;

  @override
  void initState() {
    super.initState();
    editingNote = Get.arguments as Note?;
    if (editingNote != null) {
      titleController.text = editingNote!.title;
      contentController.text = editingNote!.content;
      categoryController.text = editingNote!.category ?? '';
    }
  }

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final note = Note(
        id: editingNote?.id,
        title: titleController.text.trim(),
        content: contentController.text.trim(),
        category: categoryController.text.trim().isEmpty
            ? null
            : categoryController.text.trim(),
        createdAt: editingNote?.createdAt ?? now,
        updatedAt: now,
      );
      controller.addOrUpdateNote(note);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(editingNote == null ? 'Add Note' : 'Edit Note')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value!.trim().isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 6,
                validator: (value) =>
                    value!.trim().isEmpty ? 'Content is required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category (optional)',
                  hintText: 'e.g. Work, Personal, Ideas',
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save'),
                onPressed: _saveNote,
              )
            ],
          ),
        ),
      ),
    );
  }
}
