import 'acilKisiler.dart';
import 'package:flutter/material.dart';
import 'user_info.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});
  @override
  AnasayfaState createState() => AnasayfaState();
}

class AnasayfaState extends State<Anasayfa> {
  String textField1 = '';
  String textField2 = '';
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
                            margin: const EdgeInsets.only( top: 91, bottom: 61, left: 29),
                            child: Text(
                              "YARDIM ÇAĞIR",
                              style: TextStyle(
                                color: Color(0xFF263238),
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IntrinsicHeight(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Color(0xFFFF0000),
                              ),
                              padding: const EdgeInsets.only( top: 33, bottom: 33, left: 16, right: 16),
                              margin: const EdgeInsets.only( bottom: 40, left: 29, right: 29),
                              width: double.infinity,
                              child: Row(
                                  children: [
                                    Container(
                                        width: 84,
                                        height: 35,
                                        child: Image.network(
                                          "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/gol3gopo_expires_30_days.png",
                                          fit: BoxFit.fill,
                                        )
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              IntrinsicHeight(
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: double.infinity,
                                                  child: TextField(
                                                    style: TextStyle(
                                                      color: Color(0xFFFFFFFF),
                                                      fontSize: 32,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() { textField1 = value; });
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText: "    Hızlı Yardım",
                                                      isDense: true,
                                                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]
                                        ),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ),
                          IntrinsicHeight(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Color(0xFF90A4AE),
                              ),
                              padding: const EdgeInsets.only( top: 12, bottom: 12, left: 10, right: 10),
                              margin: const EdgeInsets.only( bottom: 40, left: 29, right: 29),
                              width: double.infinity,
                              child: Row(
                                  children: [
                                    Container(
                                        width: 69,
                                        height: 69,
                                        child: Image.network(
                                          "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/8ha6n32n_expires_30_days.png",
                                          fit: BoxFit.fill,
                                        )
                                    ),
                                    Expanded(
                                      child: IntrinsicHeight(
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(vertical: 9),
                                          width: double.infinity,
                                          child: TextField(
                                            style: TextStyle(
                                              color: Color(0xFFFFFFFF),
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            onChanged: (value) {
                                              setState(() { textField2 = value; });
                                            },
                                            decoration: InputDecoration(
                                              hintText: "Konumumu paylaş",
                                              isDense: true,
                                              contentPadding: EdgeInsets.symmetric(vertical: 0),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Color(0xFF90A4AE),
                            ),
                            margin: const EdgeInsets.only( bottom: 40, left: 31, right: 31),
                            height: 90,
                            width: double.infinity,
                            child: SizedBox(),
                          ),
                          IntrinsicHeight(
                            child: Container(
                              margin: const EdgeInsets.only( bottom: 91, left: 44, right: 44),
                              width: double.infinity,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: IntrinsicHeight(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            color: Color(0xFF90A4AE),
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          margin: const EdgeInsets.only( right: 47),
                                          width: double.infinity,
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    margin: const EdgeInsets.symmetric(horizontal: 26),
                                                    height: 75,
                                                    width: double.infinity,
                                                    child: Image.network(
                                                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/fp9cumfa_expires_30_days.png",
                                                      fit: BoxFit.fill,
                                                    )
                                                ),
                                              ]
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: IntrinsicHeight(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            color: Color(0xFF90A4AE),
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          width: double.infinity,
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    margin: const EdgeInsets.only( left: 36),
                                                    width: 75,
                                                    height: 75,
                                                    child: Image.network(
                                                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/vixwrgce_expires_30_days.png",
                                                      fit: BoxFit.fill,
                                                    )
                                                ),
                                              ]
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ),
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
                              padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 21),
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Eşit boşluk dağılımı sağlar
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Acil_kisiler()),
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
                                        MaterialPageRoute(builder: (context) => Acil_kisiler()),
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
                                        MaterialPageRoute(builder: (context) => Acil_kisiler()),
                                      );
                                    },
                                    child: SizedBox(
                                      width: 38,
                                      height: 38,
                                      child: Icon(Icons.help, color: Colors.white), // örnek ek ikon
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Acil_kisiler()),
                                      );
                                    },
                                    child: SizedBox(
                                      width: 38,
                                      height: 38,
                                      child: Icon(Icons.settings, color: Colors.white), // örnek ek ikon
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => UserInfoPage()),
                                      );
                                    },
                                    child: SizedBox(
                                      width: 38,
                                      height: 38,
                                      child: Icon(Icons.person, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ],
                      )
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