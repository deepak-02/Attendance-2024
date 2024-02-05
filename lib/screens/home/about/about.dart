import 'package:flutter/material.dart';
import 'package:get/get.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black12, BlendMode.darken),
          )),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              tooltip: "back",
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          body: Center(
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Spacer(),
                      const Text(
                        'Attendance',
                        style: TextStyle(
                          // color: Colors.white,
                          fontSize: 26.0,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Version 5.1.0',
                          style: TextStyle(
                            // color: Color.fromRGBO(255, 255, 255, 0.5),
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: SizedBox(
                            width: 100.0,
                            height: 100.0,
                            child: Container(
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage(
                                      'assets/images/ic_launcher.png'),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(60.0),
                              ),
                            )),
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 32.0, bottom: 20),
                        child: Text(
                          '© 2022  PTF Team',
                          style: TextStyle(
                            //color: Color.fromRGBO(255, 255, 255, 0.5),
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 15.0),
                      //   child: TextButton(
                      //     onPressed: () {
                      //       Get.to(
                      //         () => const More(),
                      //         transition: Transition.downToUp,
                      //         duration: const Duration(milliseconds: 500),
                      //       );
                      //     },
                      //     child: Text(
                      //       'MORE',
                      //       style: TextStyle(
                      //           decoration: TextDecoration.underline,
                      //           color: Theme.of(context).primaryColor,
                      //           fontSize: 17.0,
                      //           fontWeight: FontWeight.bold),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
