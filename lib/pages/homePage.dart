
import 'package:afet_acil_durum_app/services/notiService.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  NotiService notiService = NotiService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sadece İhtiyaç Dahilinde"),
        centerTitle: true,
      ) ,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Application Home Screen"),
            ElevatedButton(
                onPressed: () async {

                  await notiService.showNotification(
                    id: 0,
                    title: "Deprem Tehlikesi",
                    body: "Güvenli alanlara geçin"
                  );
                },
                child: const Text("Send Notification")
            ),
          ],
        ),
      ),
    );
  }
}
