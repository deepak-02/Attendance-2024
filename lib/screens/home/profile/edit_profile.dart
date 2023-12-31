import 'dart:convert';
import 'dart:io';
import 'package:attendance/screens/home/about/about.dart';
import 'package:attendance/screens/password/reset_password.dart';
import 'package:attendance/widgets/big_button.dart';
import 'package:attendance/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as nav;
import 'package:image_picker/image_picker.dart';
import '../../../blocs/profileBloc/profile_bloc.dart';
import '../../../widgets/full_screen_image.dart';
import '../../../widgets/image_selection.dart';

class EditProfile extends StatefulWidget {
  const EditProfile(
      {super.key,
      required this.image,
      required this.name,
      required this.address,
      required this.phone,
      required this.batch,
      required this.designation});

  final String image;
  final String name;
  final String address;
  final String phone;
  final String batch;
  final String designation;

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController batchController = TextEditingController();
  TextEditingController designationController = TextEditingController();

  File? _image;
  String image = '';

  @override
  void initState() {
    setData();
    super.initState();
  }

  void setData() {
    setState(() {
      nameController.text = widget.name;
      addressController.text = widget.address;
      phoneController.text = widget.phone;
      batchController.text = widget.batch;
      designationController.text = widget.designation;
      image = widget.image;
      BlocProvider.of<ProfileBloc>(context).add(NameChangeEvent(widget.name));
      BlocProvider.of<ProfileBloc>(context)
          .add(AddressChangeEvent(widget.address));
      BlocProvider.of<ProfileBloc>(context).add(PhoneChangeEvent(widget.phone));
      BlocProvider.of<ProfileBloc>(context).add(BatchChangeEvent(widget.batch));
      BlocProvider.of<ProfileBloc>(context)
          .add(DesignationChangeEvent(widget.designation));
    });
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        BlocProvider.of<ProfileBloc>(context)
            .add(UploadProfileImageEvent(_image!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileBloc = context.read<ProfileBloc>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
          leading: IconButton(
            tooltip: 'back',
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              nav.Get.back();
              // nav.Get.off(Profile());
            },
          ),
          actions: [

            PopupMenuButton<String>(
              surfaceTintColor: Colors.white,
              shadowColor: Colors.white,
              color: Colors.white,
              onSelected: (value) {
                if (value == 'resetPassword') {
                  nav.Get.to(const ResetPasswordPage(page: 'profile',));
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordPage()));
                }
                // else if (value == 'about') {
                //   nav.Get.to(const About());
                //   // Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
                // }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'resetPassword',
                  child: Text('Reset Password'),
                ),
                // const PopupMenuItem<String>(
                //   value: 'about',
                //   child: Text('About'),
                // ),
              ],
            ),

          ],
        ),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is UpdateProfileSuccessState) {
              // nav.Get.off(Profile());
              nav.Get.back();
            } else if (state is UpdateProfileErrorState) {
              Fluttertoast.showToast(
                  msg: state.error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: const Color(0x3F000000),
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else if (state is UploadProfileImageSuccessState) {
              profileBloc.add(GetProfileImageEvent());
            } else if (state is GetProfileImageSuccessState) {
              setState(() {
                image = state.image;
              });
            } else if (state is RemoveProfileImageSuccessState) {
              profileBloc.add(GetProfileImageEvent());
            } else if (state is UploadProfileImageErrorState) {
              Fluttertoast.showToast(
                  msg: state.error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: const Color(0x3F000000),
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else if (state is RemoveProfileImageErrorState) {
              Fluttertoast.showToast(
                  msg: state.error,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: const Color(0x3F000000),
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
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
                                : CircleAvatar(
                                    backgroundImage:
                                        MemoryImage(base64Decode(image)),
                                  ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.white,
                                builder: (BuildContext context) {
                                  return ImageSheet(
                                    title: 'Profile Photo',
                                    tooltip: 'Remove Photo',
                                    icon: Icons.delete,
                                    onIconPress: () {
                                      profileBloc
                                          .add(RemoveProfileImageEvent());
                                    },
                                    onViewPress: () {
                                      if (image != '') {
                                        nav.Get.to(FullScreenImagePage(
                                          image: image,
                                          title: 'Profile Photo',
                                        ));
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "No Image!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:
                                                const Color(0x3F000000),
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }
                                    },
                                    onCameraPress: () {
                                      _getImage(ImageSource.camera);
                                      Navigator.pop(context);
                                    },
                                    onGalleryPress: () {
                                      _getImage(ImageSource.gallery);
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.primary,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x3F000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      InputField(
                        hintText: 'Name',
                        labelText: 'Name',
                        controller: nameController,
                        onChanged: (value) {
                          profileBloc.add(NameChangeEvent(value));
                        },
                      ),
                      InputField(
                        hintText: 'Address',
                        labelText: 'Address',
                        controller: addressController,
                        onChanged: (value) {
                          profileBloc.add(AddressChangeEvent(value));
                        },
                      ),
                      InputField(
                        hintText: 'Phone',
                        labelText: 'Phone',
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        onChanged: (value) {
                          profileBloc.add(PhoneChangeEvent(value));
                        },
                      ),
                      DropDownField(
                        hintText: 'Select Batch',
                        labelText: "Batch",
                        items: const ['Batch 1', 'Batch 2', 'Batch 3'],
                        value: batchController.text,
                        onChanged: (value) {
                          profileBloc.add(BatchChangeEvent(value!));
                        },
                      ),
                      InputField(
                        hintText: 'Designation',
                        labelText: 'Designation',
                        controller: designationController,
                        onChanged: (value) {
                          profileBloc.add(DesignationChangeEvent(value));
                        },
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      state is UpdateProfileLoadingState
                          ? const BigButtonLoading()
                          : BigButton(
                              title: "Save",
                              onPressed: () {
                                profileBloc.add(UpdateProfileEvent());
                              },
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
