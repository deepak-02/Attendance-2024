import 'dart:convert';
import 'package:attendance/screens/home/profile/edit_profile.dart';
import 'package:attendance/screens/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as nav;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../blocs/profileBloc/profile_bloc.dart';
import '../../../widgets/big_button.dart';
import '../../../widgets/full_screen_image.dart';
import '../../../widgets/user_details.dart';
import '../about/about.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String createdOn = '';
  String updatedOn = '';
  var image = '';
  String name = '';
  String email = '';
  String address = '';
  String phone = '';
  String batch = '';
  String designation = '';

  @override
  void initState() {
    BlocProvider.of<ProfileBloc>(context).add(GetProfileImageEvent());
    BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final profileBloc = context.read<ProfileBloc>();
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
              // nav.Get.offAll(Dashboard());
              nav.Get.back();
              // Navigator.of(context).pushReplacement(MaterialPageRoute(
              //   builder: (context) => const Dashboard()
              // ));
            },
          ),
          actions: [
            IconButton(
              tooltip: 'edit profile',
              icon: const Icon(Icons.edit),
              onPressed: () {
                if (name != '') {
                  nav.Get.to(EditProfile(
                          image: image,
                          name: name,
                          address: address,
                          phone: phone,
                          batch: batch,
                          designation: designation))!
                      .then((value) {
                    BlocProvider.of<ProfileBloc>(context)
                        .add(GetProfileImageEvent());
                    BlocProvider.of<ProfileBloc>(context)
                        .add(GetProfileEvent());
                  });
                }
              },
            ),
          ],
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          bloc: profileBloc,
          listener: (context, state) {
            print(state);
            if (state is GetProfileImageSuccessState) {
              setState(() {
                image = state.image;
              });
            } else if (state is GetProfileSuccessState) {
              setState(() {
                email = state.user!.email!;
                name = state.user!.name!;
                address = state.user!.address!;
                phone = state.user!.phoneNumber!;
                batch = state.user!.batch!;
                designation = state.user!.designation!;
                createdOn = state.user!.createdAt!;
                updatedOn = state.user!.updatedAt!;
              });
            } else if (state is GetProfileImageErrorState) {
              Fluttertoast.showToast(
                  msg: state.error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: const Color(0x3F000000),
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else if (state is GetProfileErrorState) {
              Fluttertoast.showToast(
                  msg: state.error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: const Color(0x3F000000),
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else if (state is LogoutSuccessState) {
              nav.Get.offAll(const LoginPage());
            } else if (state is LogoutErrorState) {
              Fluttertoast.showToast(
                  msg: "Something Wrong!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: const Color(0x3F000000),
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          },
          builder: (context, state) {
            if (state is GetProfileLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetProfileErrorState) {
              return Center(
                child: Text(state.error),
              );
            } else {
              return SingleChildScrollView(
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
                              child: image == ''
                                  ? const CircleAvatar(
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        nav.Get.to(FullScreenImagePage(
                                          image: image,
                                          title: 'Profile Photo',
                                        ));
                                      },
                                      child: CircleAvatar(
                                        backgroundImage:
                                            MemoryImage(base64Decode(image)),
                                      ),
                                    ),
                            ),
                            Text(
                              name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                            Text(
                              email,
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
                          content: address,
                        ),
                        UserDetails(
                          title: 'Phone',
                          content: phone,
                        ),
                        UserDetails(
                          title: 'Batch',
                          content: batch,
                        ),
                        UserDetails(
                          title: 'Designation',
                          content: designation,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Account Created on: ${formatTimestamp(createdOn)}",
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black26),
                        ),
                        Text(
                          "Account Updated on: ${formatTimestamp(updatedOn)}",
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black26),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                nav.Get.to(const About());
                              },
                              child: Container(
                                height: 40,
                                width: 45,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/ic_launcher.png'),
                                    fit: BoxFit.contain,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'PTF Attendance',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                                Text(
                                  '©2022 Team',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        state is LogoutLoadingState
                            ? BigOutlinedButtonLoading()
                            : BigOutlinedButtonWithIcon(
                                title: 'Logout',
                                icon: Icons.logout,
                                onPressed: () {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      surfaceTintColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0))),
                                      title: const Text("Are you sure?"),
                                      content:
                                          const Text("Do you want to logout?"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => nav.Get.back(),
                                          child: const Text('Cancel',
                                              style: TextStyle(
                                                  color: Color(0xff7f91dd))),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            profileBloc.add(LogoutEvent());
                                          },
                                          child: const Text(
                                            'OK',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ));
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

  // void logout() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var token = prefs.getString('fCMToken');
  //   // tokenRemove();
  //   prefs.clear();
  //   prefs.setString('fCMToken',token!);
  //   nav.Get.offAll(const LoginPage());
  // }

  // void tokenRemove() {BlocProvider.of<ProfileBloc>(context).add(LogoutEvent());}
}
