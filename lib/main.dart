import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bindings/initial_binding.dart';
import 'routes/app_pages.dart';
import 'themes/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure all dependencies are loaded before runApp
  await InitialBinding().dependenciesAsync();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // ✅ Use the globally registered ThemeService
  final ThemeService _themeService = Get.find<ThemeService>();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
          title: 'Notes App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: _themeService.themeMode.value,
          initialRoute: AppPages.initial,
          getPages: AppPages.routes,
        ));
  }
}
