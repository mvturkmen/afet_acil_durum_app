import 'acilKisiler.dart';
import 'package:flutter/material.dart';
import 'package:afet_acil_durum_app/services/notiService.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});
  @override
  AnasayfaState createState() => AnasayfaState();
}

class AnasayfaState extends State<Anasayfa> {
  String textField1 = '';
  String textField2 = '';
  NotiService notiService = NotiService(); // Bildirim servisi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          color: Color(0xFFFFFFFF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: Color(0xFFFFFFFF),
                  width: double.infinity,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 91,
                            bottom: 61,
                            left: 29,
                          ),
                          child: Text(
                            "YARDIM ÇAĞIR",
                            style: TextStyle(
                              color: Color(0xFF263238),
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Bildirim Gönder Butonu
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              await notiService.showNotification(
                                id: 0,
                                title: "Deprem Tehlikesi",
                                body: "Güvenli alanlara geçin",
                              );
                            },
                            child: const Text("Bildirim Gönder"),
                          ),
                        ),

                        SizedBox(height: 20),

                        /// Diğer UI bölümleri burada devam eder...

                        // Örnek alt menü (değişmeden bırakıldı)
                        IntrinsicHeight(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF90A4AE),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x40000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 17,
                              horizontal: 21,
                            ),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Acil_kisiler(),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    width: 38,
                                    height: 38,
                                    child: Image.network(
                                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/sez3gpbo_expires_30_days.png",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Acil_kisiler(),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    width: 34,
                                    height: 37,
                                    child: Image.network(
                                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/f9hv9y0f_expires_30_days.png",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Acil_kisiler(),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    width: 38,
                                    height: 38,
                                    child: Icon(
                                      Icons.help,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Acil_kisiler(),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    width: 38,
                                    height: 38,
                                    child: Icon(
                                      Icons.settings,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
