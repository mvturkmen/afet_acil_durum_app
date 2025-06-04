import 'package:afet_acil_durum_app/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:afet_acil_durum_app/pages/login.dart';
import 'package:afet_acil_durum_app/services/location/location_service.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';
import 'package:afet_acil_durum_app/background/location_tasks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool permissionGranted = await LocationService().handlePermission();
  if (!permissionGranted) {
    print('Konum izni verilmedi!');
  }

  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  // Testing
  await Workmanager().registerOneOffTask(
    "testTaskUnique",
    fetchLocationTask,
    initialDelay: const Duration(seconds: 5),
  );

  await Workmanager().registerPeriodicTask(
    "fetchLocationTaskUnique",
    fetchLocationTask,
    frequency: const Duration(minutes: 15),
    initialDelay: const Duration(seconds: 10),
  );

  final themeController = ThemeController();
  await themeController.loadTheme();

  runApp(
    ChangeNotifierProvider.value(value: themeController, child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Afet Acil Durum Uygulaması',
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const Homepage(),
    );
  }
}
