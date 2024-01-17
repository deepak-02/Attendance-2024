import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../db/admin/adminUsersModel.dart';
import '../../../widgets/full_screen_image.dart';
import '../../../widgets/user_details.dart';

class UsersProfile extends StatelessWidget {
  final AdminUsersModel user;
  const UsersProfile({super.key, required this.user});

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
        title: const Text("Profile Details"),
      ),
      body: Padding(
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
                    child: user.image == ''
                        ? const CircleAvatar(
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              Get.to(FullScreenImagePage(
                                image: user.image!,
                                title: '${user.name}',
                              ));
                            },
                            child: CircleAvatar(
                              backgroundImage:
                                  MemoryImage(base64Decode(user.image!)),
                            ),
                          ),
                  ),
                  Text(
                    "${user.name}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                  Text(
                    "${user.email}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      height: 0,
                    ),
                  ),
                  Text(
                    "${user.role}",
                    style: const TextStyle(
                      color: Colors.black26,
                      fontSize: 14,
                      height: 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              UserDetails(
                title: 'Address',
                content: "${user.address}",
              ),
              UserDetails(
                title: 'Phone',
                content: "${user.phoneNumber}",
              ),
              UserDetails(
                title: 'Batch',
                content: "${user.batch}",
              ),
              UserDetails(
                title: 'Designation',
                content: "${user.designation}",
              ),
              const Spacer(),
              Text(
                "Account Created on: ${formatTimestamp(user.createdAt!)}",
                style: const TextStyle(fontSize: 12, color: Colors.black26),
              ),
              Text(
                "Account Updated on: ${formatTimestamp(user.updatedAt!)}",
                style: const TextStyle(fontSize: 12, color: Colors.black26),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
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
