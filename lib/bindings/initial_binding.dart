import 'package:get/get.dart';
import '../services/note_service.dart';
import '../controllers/note_controller.dart';
import '../themes/theme_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {}

  Future<void> dependenciesAsync() async {
    final noteService = NoteService();
    await noteService.init();
    Get.put<NoteService>(noteService);
    Get.put<NoteController>(NoteController(noteService));

    // ✅ Register ThemeService once globally
    Get.put<ThemeService>(ThemeService());
  }
}
