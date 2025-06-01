import 'package:flutter/material.dart';

class EmergencyContact extends StatefulWidget {
  const EmergencyContact({super.key});
  @override
  EmergencyContactState createState() => EmergencyContactState();
}
class EmergencyContactState extends State<EmergencyContact> {
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
                            margin: const EdgeInsets.only( top: 73, bottom: 13, left: 28),
                            width: 296,
                            child: Text(
                              "ACİL DURUM KİŞİLERİ",
                              style: TextStyle(
                                color: Color(0xFF263238),
                                fontSize: 55,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IntrinsicHeight(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFFFFFFFF),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xFFFFFFFF),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x40000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.only( top: 17, bottom: 17, left: 20, right: 20),
                              margin: const EdgeInsets.only( bottom: 28, left: 28, right: 28),
                              width: double.infinity,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color(0xFFFFFFFF),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x40000000),
                                            blurRadius: 4,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      margin: const EdgeInsets.only( right: 40),
                                      width: 104,
                                      height: 79,
                                      child: SizedBox(),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Color(0xFFFFFFFF),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0x40000000),
                                              blurRadius: 4,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        height: 79,
                                        width: double.infinity,
                                        child: SizedBox(),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ),
                          IntrinsicHeight(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFFFFFFFF),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xFFFFFFFF),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x40000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.only( top: 17, bottom: 17, left: 20, right: 20),
                              margin: const EdgeInsets.only( bottom: 28, left: 30, right: 30),
                              width: double.infinity,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color(0xFFFFFFFF),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x40000000),
                                            blurRadius: 4,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      margin: const EdgeInsets.only( right: 40),
                                      width: 104,
                                      height: 79,
                                      child: SizedBox(),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Color(0xFFFFFFFF),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0x40000000),
                                              blurRadius: 4,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        height: 79,
                                        width: double.infinity,
                                        child: SizedBox(),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ),
                          IntrinsicHeight(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFFFFFFFF),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xFFFFFFFF),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x40000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.only( top: 17, bottom: 17, left: 20, right: 20),
                              margin: const EdgeInsets.only( bottom: 116, left: 30, right: 30),
                              width: double.infinity,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Color(0xFFFFFFFF),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x40000000),
                                            blurRadius: 4,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      margin: const EdgeInsets.only( right: 40),
                                      width: 104,
                                      height: 79,
                                      child: SizedBox(),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: Color(0xFFFFFFFF),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0x40000000),
                                              blurRadius: 4,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        height: 79,
                                        width: double.infinity,
                                        child: SizedBox(),
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                          ),
                          IntrinsicWidth(
                            child: IntrinsicHeight(
                              child: Container(
                                margin: const EdgeInsets.only( bottom: 34, left: 158),
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      IntrinsicWidth(
                                        child: IntrinsicHeight(
                                          child: Container(
                                            margin: const EdgeInsets.only( top: 44, right: 59),
                                            child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                            width: 102,
                                                            height: 85,
                                                            child: Image.network(
                                                              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/d47zn3ct_expires_30_days.png",
                                                              fit: BoxFit.fill,
                                                            )
                                                        ),
                                                      ]
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    left: 0,
                                                    right: 0,
                                                    child: IntrinsicHeight(
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
                                                        padding: const EdgeInsets.only( top: 20, bottom: 19, left: 31),
                                                        transform: Matrix4.translationValues(158, 34, 0),
                                                        width: 412,
                                                        child: Row(
                                                            children: [
                                                              Container(
                                                                  margin: const EdgeInsets.only( right: 212),
                                                                  width: 38,
                                                                  height: 38,
                                                                  child: Image.network(
                                                                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/s4g779th_expires_30_days.png",
                                                                    fit: BoxFit.fill,
                                                                  )
                                                              ),
                                                              Container(
                                                                  margin: const EdgeInsets.only( right: 47),
                                                                  width: 38,
                                                                  height: 30,
                                                                  child: Image.network(
                                                                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/ryt8ckht_expires_30_days.png",
                                                                    fit: BoxFit.fill,
                                                                  )
                                                              ),
                                                              Container(
                                                                  width: 34,
                                                                  height: 30,
                                                                  child: Image.network(
                                                                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/4tq95so9_expires_30_days.png",
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
                                      ),
                                      InkWell(
                                        onTap: () { print('Pressed'); },
                                        child: IntrinsicWidth(
                                          child: IntrinsicHeight(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: Color(0xFFD9D9D9),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0x40000000),
                                                    blurRadius: 4,
                                                    offset: Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              padding: const EdgeInsets.all(13),
                                              child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        width: 40,
                                                        height: 40,
                                                        child: Image.network(
                                                          "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/i98fivvk_expires_30_days.png",
                                                          fit: BoxFit.fill,
                                                        )
                                                    ),
                                                  ]
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]
                                ),
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