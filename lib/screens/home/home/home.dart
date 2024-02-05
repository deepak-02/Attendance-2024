import 'dart:convert';
import 'package:attendance/screens/home/leave/request_leave.dart';
import 'package:attendance/screens/home/profile/profile.dart';
import 'package:attendance/widgets/big_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as nav;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slidable_button/slidable_button.dart';

import '../../../blocs/homeBloc/home_bloc.dart';
import '../../AdminScreens/add_new_admin.dart';
import '../../AdminScreens/attendance/list_attendance_admin.dart';
import '../../AdminScreens/leave/leave_requests_admin.dart';
import '../../AdminScreens/user/all_users.dart';
import '../late/late_requests.dart';
import '../late/request_late.dart';
import '../leave/leave_requests.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String name = '';
  String email = '';

  var image = '';
  String status = '';

  String? role = 'user';

  Future<void> scanQRIn() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    setState(() {
      BlocProvider.of<HomeBloc>(context)
          .add(MarkAttendance(qrCode: barcodeScanRes, lastScan: 'in'));
    });
  }

  Future<void> scanQROut() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    setState(() {
      BlocProvider.of<HomeBloc>(context)
          .add(MarkAttendance(qrCode: barcodeScanRes, lastScan: 'out'));
    });
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name')!;
      email = prefs.getString('email')!;
      role = prefs.getString('role');
    });
    callApi();
  }

  callApi() {
    BlocProvider.of<HomeBloc>(context).add(UploadFCMToken());
    BlocProvider.of<HomeBloc>(context).add(GetProfileImage());
    BlocProvider.of<HomeBloc>(context).add(GetAttendanceStatus());
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = context.read<HomeBloc>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: const Text('title'),
      // ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is GetProfileImageSuccess) {
            setState(() {
              image = state.image;
            });
          } else if (state is AttendanceStatusSuccess) {
            setState(() {
              status = state.status;
            });
          } else if (state is MarkAttendanceInvalid) {
            Fluttertoast.showToast(
                msg: state.message,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: const Color(0x3F000000),
                textColor: Colors.white,
                fontSize: 16.0);
          } else if (state is MarkAttendanceError) {
            Fluttertoast.showToast(
                msg: "Error! Try again.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: const Color(0x3F000000),
                textColor: Colors.white,
                fontSize: 16.0);
          } else if (state is MarkAttendanceSuccess) {
            Fluttertoast.showToast(
                msg: "Attendance Marked",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: const Color(0x3F000000),
                textColor: Colors.white,
                fontSize: 16.0);
            homeBloc.add(GetAttendanceStatus());
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                // physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Welcome\n',
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                text: name == '' ? 'User' : name,
                                style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    color: Theme.of(context).primaryColor,
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                        Tooltip(
                          message: "Profile",
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => const Profile()
                              // )).then((value) { homeBloc.add(GetProfileImage());});
                              nav.Get.to(const Profile())!.then((value) {
                                callApi();
                                setState(() {});
                              });
                            },
                            child: image == ''
                                ? const CircleAvatar(
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundImage:
                                        MemoryImage(base64Decode(image)),
                                  ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Scan your QR code to mark your attendance',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black45),
                    ),
                    // RichText(
                    //   text: TextSpan(
                    //     text: 'Scan your QR code to mark attendance for',
                    //     style: const TextStyle(
                    //         fontSize: 20,
                    //         fontWeight: FontWeight.w400,
                    //         color: Colors.black45),
                    //     children: <TextSpan>[
                    //       TextSpan(
                    //         text: ' Prathibhatheeram Foundation',
                    //         style: TextStyle(
                    //             fontSize: 20,
                    //             fontWeight: FontWeight.w900,
                    //             color: Theme.of(context).primaryColor),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                        width: 100,
                        child: Lottie.asset(
                            'assets/lottie/arrow-down-purple.json')),
                    Stack(
                      children: [
                        Lottie.asset('assets/lottie/snowing.json',
                            height: 270, frameRate: FrameRate(120)),
                        Container(
                          decoration: ShapeDecoration(
                            color: const Color(0x123675FC),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 0.50),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 5, bottom: 20),
                            child: Column(
                              children: [
                                if (status != '')
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Current Status for today",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                      Container(
                                        // width: 130,
                                        // height: 40,
                                        decoration: ShapeDecoration(
                                          color: status == 'out'
                                              ? const Color(0xFFFF0000)
                                              : status == 'in'
                                                  ? const Color(0xff08de00)
                                                  : const Color(0xFFFFA52F),
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                width: 1,
                                                color: Color(0xFFA5A5A5)),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          child: Text(
                                            status.toUpperCase(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                const Text("Slide to mark in"),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: HorizontalSlidableButton(
                                    width:
                                        MediaQuery.of(context).size.width / 1,
                                    height: 70,
                                    buttonWidth: 70,
                                    borderRadius: BorderRadius.circular(100),
                                    isRestart: true,
                                    initialPosition:
                                        SlidableButtonPosition.start,
                                    color: const Color(0x4cc7c7c7),
                                    buttonColor: Theme.of(context)
                                        .primaryColor, //const Color(0xff1662ef),
                                    dismissible: false,
                                    autoSlide: true,
                                    label: Center(
                                        child: state is MarkInAttendanceLoading
                                            ? const CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                            : const Icon(
                                                Icons.arrow_forward,
                                                size: 30,
                                                color: Colors.white,
                                              )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 70),
                                            child: Opacity(
                                              opacity: 0.8,
                                              child: Shimmer.fromColors(
                                                baseColor: Colors.black26,
                                                highlightColor: Colors.white,
                                                child: Text(
                                                  state is MarkInAttendanceLoading
                                                      ? "Loading... please wait"
                                                      : "Slide to mark attendance",
                                                  style: const TextStyle(
                                                      color: Color(0xc5a9a9a9),
                                                      fontSize: 13),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            'IN',
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onChanged: (position) {
                                      setState(() {
                                        if (position ==
                                            SlidableButtonPosition.end) {
                                          state is MarkInAttendanceLoading
                                              ? null
                                              : scanQRIn();
                                        } else {}
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                const Text("Slide to mark out"),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: HorizontalSlidableButton(
                                    width:
                                        MediaQuery.of(context).size.width / 1,
                                    height: 70,
                                    buttonWidth: 70,
                                    initialPosition: SlidableButtonPosition.end,
                                    borderRadius: BorderRadius.circular(100),
                                    isRestart: true,
                                    color: const Color(0x4cc7c7c7),
                                    buttonColor: Theme.of(context)
                                        .primaryColor, //const Color(0xff1662ef),
                                    dismissible: false,
                                    autoSlide: true,
                                    label: Center(
                                        child: state is MarkOutAttendanceLoading
                                            ? const CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                            : const Icon(
                                                Icons.arrow_back,
                                                size: 30,
                                                color: Colors.white,
                                              )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'OUT',
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 70),
                                            child: Opacity(
                                              opacity: 0.8,
                                              child: Shimmer.fromColors(
                                                direction: ShimmerDirection.rtl,
                                                baseColor: Colors.black26,
                                                highlightColor: Colors.white,
                                                child: Text(
                                                  state is MarkOutAttendanceLoading
                                                      ? "Loading... please wait"
                                                      : "Slide to mark attendance",
                                                  style: const TextStyle(
                                                      color: Color(0xc5a9a9a9),
                                                      fontSize: 13),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onChanged: (position) {
                                      setState(() {
                                        if (position ==
                                            SlidableButtonPosition.start) {
                                          state is MarkOutAttendanceLoading
                                              ? null
                                              : scanQROut();
                                        } else {}
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // if(tasks)
                    // TextButton(
                    //   onPressed: () {  },
                    //   child: Text(
                    //     'Your tasks: 0',
                    //     style: TextStyle(
                    //         fontSize: 20,
                    //         decoration: TextDecoration.underline,
                    //         decorationThickness: 2,
                    //         decorationColor: Colors.black26,
                    //         fontWeight: FontWeight.w400,
                    //         color: Colors.black),
                    //   ),
                    // ),

                    const SizedBox(
                      height: 10,
                    ),

                    if (role == 'admin')
                      BigButton(
                        title: "Users",
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        onPressed: () {
                          nav.Get.to(const AllUsers());
                        },
                      ),
                    if (role == 'admin')
                      const SizedBox(
                        height: 16,
                      ),

                    if (role == 'admin')
                      BigButton(
                        title: "Attendances",
                        onPressed: () {
                          nav.Get.to(const ListAttendanceAdmin());
                        },
                      )
                    else
                      BigButton(
                        title: "Make a leave request",
                        onPressed: () {
                          nav.Get.to(const RequestLeave());
                        },
                      ),
                    const SizedBox(
                      height: 16,
                    ),

                    if (role == 'admin')
                      BigOutlinedButton(
                        title: "Leave Requests",
                        onPressed: () {
                          nav.Get.to(const LeaveRequestsAdmin());
                        },
                      )
                    else
                      BigOutlinedButton(
                        title: "View your leave requests",
                        onPressed: () {
                          nav.Get.to(const LeaveRequests());
                        },
                      ),

                    if (email == "ptfattendance@gmail.com" ||
                        email == "ptfattendanceapp@gmail.com")
                      TextButton(
                        onPressed: () {
                          nav.Get.to(const AddNewAdmin());
                        },
                        child: Text(
                          "Register New Admin",
                          style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              decoration: TextDecoration.underline,
                              decorationColor: Theme.of(context).primaryColor),
                        ),
                      ),

                    const SizedBox(
                      height: 45,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            nav.Get.to(RequestLate());
                          },
                          child: Stack(
                            alignment: Alignment.topCenter,
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 90,
                                height: 100,
                                alignment: Alignment.center,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7)),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x3F000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 4),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: role == 'admin'
                                    ? const Text(
                                        'Add Late',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFF6D35A4),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            height: 1,
                                            letterSpacing: 1),
                                      )
                                    : const Text(
                                        'Request\nLate',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xFF6D35A4),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            height: 1,
                                            letterSpacing: 1),
                                      ),
                              ),
                              Positioned(
                                top: -30,
                                left: 15,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: role == 'admin'
                                      ? ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            side: const BorderSide(
                                                width: 0.5,
                                                color: Colors.black12),
                                          ),
                                          image: const DecorationImage(
                                            image: AssetImage(
                                                'assets/images/business.png'),
                                          ),
                                        )
                                      : ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              side: const BorderSide(
                                                  width: 0.5,
                                                  color: Colors.black12)),
                                        ),
                                  child: role == 'admin'
                                      ? Container()
                                      : Lottie.asset(
                                          'assets/lottie/running-robo.json',
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            nav.Get.to(LateRequests());
                          },
                          child: Stack(
                            alignment: Alignment.topCenter,
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 90,
                                height: 100,
                                alignment: Alignment.center,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7)),
                                  shadows: const [
                                    BoxShadow(
                                      color: Color(0x3F000000),
                                      blurRadius: 4,
                                      offset: Offset(0, 4),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: const Text(
                                  'View Late Requests',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xFF6D35A4),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                      letterSpacing: 1),
                                ),
                              ),
                              Positioned(
                                top: -30,
                                left: 15,
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: ShapeDecoration(
                                    image: const DecorationImage(
                                      image:
                                          AssetImage('assets/images/list.png'),
                                      fit: BoxFit.contain,
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        side: const BorderSide(
                                            width: 0.5, color: Colors.black12)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
