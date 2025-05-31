import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/note_controller.dart';
import '../themes/theme_service.dart';

class HomeView extends StatelessWidget {
  final NoteController controller = Get.find();
  final ThemeService _themeService = Get.find<ThemeService>();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Notes',
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6,
                color: isDark ? Colors.white : Colors.black),
            onPressed: () => _themeService.toggleTheme(),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => controller.sortField.value = value,
            icon: Icon(Icons.sort, color: isDark ? Colors.white : Colors.black),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'title', child: Text('Sort by Title')),
              const PopupMenuItem(
                  value: 'createdAt', child: Text('Sort by Date')),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              onChanged: (val) => controller.searchQuery.value = val,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle:
                    TextStyle(color: isDark ? Colors.white54 : Colors.black54),
                border: const OutlineInputBorder(),
                prefixIcon: Icon(Icons.search,
                    color: isDark ? Colors.white : Colors.black),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        final notes = controller.filteredNotes;
        if (notes.isEmpty) {
          return Center(
            child: Text(
              'No notes found.',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: notes.length,
          itemBuilder: (_, i) {
            final note = notes[i];
            final formattedDate =
                DateFormat.yMMMd().format(note.updatedAt.toLocal());

            return Dismissible(
              key: Key(note.id.toString()),
              background: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.red[700] : Colors.red[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.delete,
                    color: isDark ? Colors.white : Colors.red[900]),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  return await Get.dialog(AlertDialog(
                    title: const Text('Delete Note'),
                    content: const Text(
                        'Are you sure you want to delete this note?'),
                    actions: [
                      TextButton(
                          onPressed: () => Get.back(result: false),
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: () => Get.back(result: true),
                          child: const Text('Delete')),
                    ],
                  ));
                }
                return false;
              },
              onDismissed: (direction) {
                if (direction == DismissDirection.startToEnd) {
                  controller.deleteNote(note);
                }
              },
              child: Card(
                color: isDark ? Colors.blueGrey[700] : Colors.blue[100],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 5,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => Get.toNamed('/form', arguments: note),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            note.content,
                            maxLines: 7,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (note.category != null && note.category!.isNotEmpty)
                          Text(
                            'Category: ${note.category}',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: isDark ? Colors.white60 : Colors.grey[700],
                            ),
                          ),
                        const SizedBox(height: 6),
                        Text(
                          'Updated: $formattedDate',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white60 : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/form'),
        child: Icon(Icons.add, color: isDark ? Colors.white : Colors.black),
        backgroundColor: isDark ? Colors.blueGrey[700] : Colors.blue,
      ),
    );
  }
}
