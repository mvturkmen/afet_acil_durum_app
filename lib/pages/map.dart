import 'package:flutter/material.dart';
class MapArea extends StatefulWidget {
  const MapArea({super.key});
  @override
  MapAreaState createState() => MapAreaState();
}
class MapAreaState extends State<MapArea> {
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
                            margin: const EdgeInsets.only( top: 52, bottom: 34, left: 46),
                            width: 271,
                            child: Text(
                              "TOPLANMA NOKTALARI",
                              style: TextStyle(
                                color: Color(0xFF263238),
                                fontSize: 55,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IntrinsicHeight(
                            child: Container(
                              margin: const EdgeInsets.only( bottom: 1),
                              width: double.infinity,
                              child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only( bottom: 92),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              color: Color(0xFF90A4AE),
                                              margin: const EdgeInsets.symmetric(horizontal: 15),
                                              height: 608,
                                              width: double.infinity,
                                              child: SizedBox(),
                                            ),
                                          ]
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 41,
                                      left: 155,
                                      right: 155,
                                      height: 85,
                                      child: Container(
                                          height: 85,
                                          width: double.infinity,
                                          child: Image.network(
                                            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/dhsi8vhc_expires_30_days.png",
                                            fit: BoxFit.fill,
                                          )
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
                              padding: const EdgeInsets.only( top: 17, bottom: 22, left: 27),
                              width: double.infinity,
                              child: Row(
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only( right: 35),
                                        width: 38,
                                        height: 38,
                                        child: Image.network(
                                          "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/0bwzb9ff_expires_30_days.png",
                                          fit: BoxFit.fill,
                                        )
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only( right: 144),
                                        width: 34,
                                        height: 37,
                                        child: Image.network(
                                          "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/xwqmgudg_expires_30_days.png",
                                          fit: BoxFit.fill,
                                        )
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only( right: 47),
                                        width: 38,
                                        height: 30,
                                        child: Image.network(
                                          "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/43wh7z5r_expires_30_days.png",
                                          fit: BoxFit.fill,
                                        )
                                    ),
                                    Container(
                                        width: 34,
                                        height: 30,
                                        child: Image.network(
                                          "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/BDiNJFehUq/yya0iclm_expires_30_days.png",
                                          fit: BoxFit.fill,
                                        )
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