import 'package:flutter/material.dart';
import 'package:get/get.dart';

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black12, BlendMode.multiply),
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
          body: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Spacer(),
                    const Text(
                      'Attendance',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        // color: Colors.white,
                        fontSize: 26.0,
                      ),
                    ),
                    // Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        child: const Text(
                          'An app to manage the attendance\n of PTF trainees',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            overflow: TextOverflow.fade,
                            //color: Color.fromRGBO(255, 255, 255, 0.5),
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),

                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Column(
                        children: [
                          const Text(
                            'Developed by\n ',
                            style: TextStyle(
                              // color: Color.fromRGBO(255, 255, 255, 0.5),
                              fontSize: 22.0,
                            ),
                          ),
                          DataTable(
                            showBottomBorder: true,
                            border: const TableBorder(
                                top: BorderSide(width: 1),
                                bottom: BorderSide(width: 1),
                                left: BorderSide(width: 1),
                                right: BorderSide(width: 1),
                                horizontalInside:
                                    BorderSide(width: 1, color: Colors.black54),
                                verticalInside: BorderSide(width: 1)),
                            columns:  <DataColumn>[
                              DataColumn(
                                label: Text(
                                  'Fields',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Developers',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ],
                            rows: const <DataRow>[
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(
                                    'Flutter',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  )),
                                  DataCell(Text(
                                    'Deepak, Niketh',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  )),
                                ],
                              ),
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(
                                    'Spring Boot',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  )),
                                  DataCell(Text(
                                    'Akhil, Sreehari',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  )),
                                ],
                              ),
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(
                                    'Vue.js',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  )),
                                  DataCell(Text(
                                    'Binil, Kanishma',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  )),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.only(top: 32.0),
                      child: Text(
                        'Co-ordinated by\nSreeda Manoj\n',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          // color: Color.fromRGBO(255, 255, 255, 0.5),
                          fontSize: 22.0,
                        ),
                      ),
                    ),
                     Text(
                      '©PTF',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        // color: Color.fromRGBO(255, 255, 255, 0.5),
                        color: Theme.of(context).primaryColor,
                        fontSize: 12.0,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
