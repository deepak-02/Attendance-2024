import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../db/admin/adminAttendanceModel.dart';
import '../../../widgets/big_button.dart';
import '../../../widgets/full_screen_image.dart';
import '../../../widgets/user_details.dart';
import '../../home/Attendance/my_attendance.dart';

class UserDetailsAdmin extends StatefulWidget {
  final Attendance details;

  const UserDetailsAdmin({super.key, required this.details});

  @override
  _UserDetailsAdminState createState() => _UserDetailsAdminState();
}

class _UserDetailsAdminState extends State<UserDetailsAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.transparent,
        leading: IconButton(
          tooltip: 'back',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text("Profile Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: widget.details.image == ''
                          ? const CircleAvatar(
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                Get.to(FullScreenImagePage(
                                  image: widget.details.image!,
                                  title: 'Profile Photo',
                                ));
                              },
                              child: CircleAvatar(
                                backgroundImage: MemoryImage(
                                    base64Decode(widget.details.image!)),
                              ),
                            ),
                    ),
                    Text(
                      "${widget.details.name}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    Text(
                      "${widget.details.email}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        height: 0,
                      ),
                    ),
                  ],
                ),
                UserDetails(
                  title: 'Address',
                  content: "${widget.details.address}",
                ),
                UserDetails(
                  title: 'Phone',
                  content: "${widget.details.phone}",
                ),
                UserDetails(
                  title: 'Batch',
                  content: "${widget.details.batch}",
                ),
                UserDetails(
                  title: 'Designation',
                  content: "${widget.details.designation}",
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Account Created on: ${formatTimestamp(widget.details.createdAt!)}",
                  style: const TextStyle(fontSize: 12, color: Colors.black26),
                ),
                Text(
                  "Account Updated on: ${formatTimestamp(widget.details.updatedAt!)}",
                  style: const TextStyle(fontSize: 12, color: Colors.black26),
                ),
                const SizedBox(
                  height: 20,
                ),
                BigButton(
                  title: 'View Attendance',
                  onPressed: () {
                    Get.to(MyAttendance(
                      email: widget.details.email,
                    ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatTimestamp(String timestamp) {
    if (timestamp == '') {
      return '';
    } else {
      DateTime dateTime = DateTime.parse(timestamp).toLocal();
      String formattedDateTime =
          DateFormat('MMM dd yyyy, hh:mm a').format(dateTime);
      return formattedDateTime;
    }
  }
}
