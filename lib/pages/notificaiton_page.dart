import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          color: const Color(0xFFFFFFFF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: const Color(0xFFFFFFFF),
                  width: double.infinity,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 81, bottom: 28, left: 35),
                          child: const Text(
                            "BİLDİRİMLER\n",
                            style: TextStyle(
                              color: Color(0xFF263238),
                              fontSize: 55,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IntrinsicHeight(
                          child: Container(
                            width: double.infinity,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 105),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      IntrinsicHeight(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(29),
                                            color: const Color(0xFF90A4AE),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0x40000000),
                                                blurRadius: 4,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.only(top: 36, bottom: 362),
                                          margin: const EdgeInsets.symmetric(horizontal: 20),
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: List.generate(5, (index) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(7),
                                                  color: const Color(0xFFFFFFFF),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: const Color(0x40000000),
                                                      blurRadius: 4,
                                                      offset: const Offset(0, 4),
                                                    ),
                                                  ],
                                                ),
                                                margin: const EdgeInsets.only(bottom: 12, left: 21, right: 21),
                                                height: 35,
                                                width: double.infinity,
                                                child: const SizedBox(),
                                              );
                                            }),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Positioned(
                                  bottom: 42,
                                  left: 147,
                                  width: 102,
                                  height: 85,
                                  child: Image(
                                    image: NetworkImage(
                                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/5pq04jd0_expires_30_days.png",
                                    ),
                                    fit: BoxFit.fill,
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
              IntrinsicHeight(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF90A4AE),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x40000000),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 33),
                        width: 38,
                        height: 38,
                        child: const Image(
                          image: NetworkImage(
                            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/vv6odcs5_expires_30_days.png",
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        width: 34,
                        height: 37,
                        child: const Image(
                          image: NetworkImage(
                            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/g5vqdknx_expires_30_days.png",
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.only(right: 47),
                        width: 38,
                        height: 30,
                        child: const Image(
                          image: NetworkImage(
                            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/lkvks9cs_expires_30_days.png",
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        width: 34,
                        height: 30,
                        child: const Icon(Icons.notifications, color: Colors.white),
                      ),
                    ],
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
