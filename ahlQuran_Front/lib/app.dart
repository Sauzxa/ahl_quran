import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_doctarine_of_the_ppl_of_the_quran/web/pages/home.dart';
import 'controllers/theme.dart';
import 'system/utils/theme.dart';
import 'routes/app_screens.dart';
import 'bindings/starter.dart';
import 'testpage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeController.mode.value,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          initialBinding: StarterBinding(),
          getPages: AppScreens.routes,
          locale: const Locale('ar'),
          fallbackLocale: const Locale('ar'),
          home: HomePage(),
        ));
  }
}
