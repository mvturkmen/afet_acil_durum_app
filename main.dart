import 'package:afet_acil_durum_app/screens/homePage.dart';
import 'package:afet_acil_durum_app/services/notiService.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // init notifications
  NotiService().initNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/home',
      routes: {
        // '/logIn' : (context) => const LogInPage() ,
        '/home' : (context) => const Homepage(),
      },
    );
  }
}
