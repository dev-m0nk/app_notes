import 'package:get/get.dart';
import '../views/home_view.dart';
import '../views/note_form_view.dart';

class AppPages {
  static const initial = '/';

  static final routes = [
    GetPage(name: '/', page: () => HomeView()),
    GetPage(name: '/form', page: () => NoteFormView()),
  ];
}
