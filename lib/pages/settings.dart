import 'package:flutter/material.dart';
class Settings extends StatefulWidget {
  const Settings({super.key});
  @override
  SettingsState createState() => SettingsState();
}
class SettingsState extends State<Settings> {
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
                            margin: const EdgeInsets.only( top: 52, bottom: 41, left: 30),
                            child: Text(
                              "Ayarlar",
                              style: TextStyle(
                                color: Color(0xFF263238),
                                fontSize: 55,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            color: Color(0xFF90A4AE),
                            margin: const EdgeInsets.only( bottom: 29, left: 30, right: 30),
                            height: 113,
                            width: double.infinity,
                            child: SizedBox(),
                          ),
                          Container(
                            color: Color(0xFF90A4AE),
                            margin: const EdgeInsets.only( bottom: 21, left: 30, right: 30),
                            height: 66,
                            width: double.infinity,
                            child: SizedBox(),
                          ),
                          Container(
                            color: Color(0xFF90A4AE),
                            margin: const EdgeInsets.only( bottom: 21, left: 30, right: 30),
                            height: 66,
                            width: double.infinity,
                            child: SizedBox(),
                          ),
                          Container(
                            color: Color(0xFF90A4AE),
                            margin: const EdgeInsets.only( bottom: 21, left: 30, right: 30),
                            height: 66,
                            width: double.infinity,
                            child: SizedBox(),
                          ),
                          Container(
                            color: Color(0xFF90A4AE),
                            margin: const EdgeInsets.only( bottom: 166, left: 30, right: 30),
                            height: 66,
                            width: double.infinity,
                            child: SizedBox(),
                          ),
                          Container(
                            margin: const EdgeInsets.only( bottom: 32, left: 165),
                            height: 1,
                            width: double.infinity,
                            child: SizedBox(),
                          ),
                          InkWell(
                            onTap: () { print('Pressed'); },
                            child: Container(
                                margin: const EdgeInsets.only( left: 150),
                                width: 102,
                                height: 85,
                                child: Image.network(
                                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/81yxot3g_expires_30_days.png",
                                  fit: BoxFit.fill,
                                )
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
                              padding: const EdgeInsets.only( top: 20, bottom: 19, left: 25),
                              width: 412,
                              child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () { print('Pressed'); },
                                      child: Container(
                                          margin: const EdgeInsets.only( right: 41),
                                          width: 38,
                                          height: 38,
                                          child: Image.network(
                                            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/lrryrv8r_expires_30_days.png",
                                            fit: BoxFit.fill,
                                          )
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () { print('Pressed'); },
                                      child: Container(
                                          margin: const EdgeInsets.only( right: 150),
                                          width: 34,
                                          height: 37,
                                          child: Image.network(
                                            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/2bz2niln_expires_30_days.png",
                                            fit: BoxFit.fill,
                                          )
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () { print('Pressed'); },
                                      child: Container(
                                          margin: const EdgeInsets.only( right: 38),
                                          width: 38,
                                          height: 30,
                                          child: Image.network(
                                            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/jd9hqgvr_expires_30_days.png",
                                            fit: BoxFit.fill,
                                          )
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () { print('Pressed'); },
                                      child: Container(
                                          width: 34,
                                          height: 30,
                                          child: Image.network(
                                            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/22j4aquq_expires_30_days.png",
                                            fit: BoxFit.fill,
                                          )
                                      ),
                                    ),
                                  ]
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