import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../blocs/adminBloc/admin_bloc.dart';
import '../../widgets/big_button.dart';
import '../../widgets/input_field.dart';
import '../home/dashboard.dart';

class AddNewAdmin extends StatefulWidget {
  const AddNewAdmin({super.key});

  @override
  _AddNewAdminState createState() => _AddNewAdminState();
}

class _AddNewAdminState extends State<AddNewAdmin> {
  bool obSecure = true;

  @override
  Widget build(BuildContext context) {
    final signUpBloc = context.read<AdminBloc>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocConsumer<AdminBloc, AdminState>(
          listener: (context, state) {
            if (state is AdminSignupSuccess) {
              Fluttertoast.showToast(
                  msg: "Registration Successful",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: const Color(0x3F000000),
                  textColor: Colors.white,
                  fontSize: 16.0);
              Get.offAll(const Dashboard());
            } else if (state is AdminSignupError) {
              Fluttertoast.showToast(
                  msg: "Registration Failed!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: const Color(0x3F000000),
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            tooltip: "back",
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ],
                      ),
                      // Container(
                      //   height: 100,
                      //   decoration: BoxDecoration(
                      //     image: const DecorationImage(
                      //       image:
                      //       AssetImage('assets/images/ic_launcher.png'),
                      //       fit: BoxFit.contain,
                      //     ),
                      //     borderRadius: BorderRadius.circular(60.0),
                      //   ),
                      // ),
                      Stack(
                        children: <Widget>[
                          Text(
                            'Admin Sign Up',
                            style: TextStyle(
                              fontSize: 40,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 6
                                ..color = const Color(0xFF6F42C0),
                            ),
                          ),
                          const Text(
                            'Admin Sign Up',
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black26,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      InputField(
                        hintText: "Name",
                        prefixIcon: const Icon(Icons.person),
                        onChanged: (val) {
                          signUpBloc.add(NameChangeEvent(name: val));
                        },
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                      ),
                      InputField(
                        hintText: "Email",
                        prefixIcon: const Icon(Icons.alternate_email),
                        onChanged: (val) {
                          signUpBloc.add(EmailChangeEvent(email: val));
                        },
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TextFormField(
                          onChanged: (val) {
                            signUpBloc.add(PasswordChangeEvent(password: val));
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            hintText: 'Password',
                            prefixIcon: const Icon(Icons.key),
                            suffixIcon: IconButton(
                              tooltip: obSecure ? "show" : "hide",
                              onPressed: () {
                                setState(() {
                                  obSecure = !obSecure;
                                });
                              },
                              icon: Icon(obSecure
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                          obscureText: obSecure,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      InputField(
                        hintText: "Phone",
                        prefixIcon: const Icon(Icons.phone),
                        onChanged: (val) {
                          signUpBloc.add(PhoneChangeEvent(phone: val));
                        },
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        textInputAction: TextInputAction.next,
                      ),
                      InputField(
                        hintText: "Address",
                        prefixIcon: const Icon(Icons.home),
                        onChanged: (val) {
                          signUpBloc.add(AddressChangeEvent(address: val));
                        },
                        // textInputAction: TextInputAction.next,
                      ),
                      DropDownField(
                        hintText: 'Select Batch',
                        items: const ['Batch 1', 'Batch 2', 'Batch 3'],
                        onChanged: (value) {
                          // Handle the selected batch
                          signUpBloc.add(BatchChangeEvent(batch: value!));
                        },
                      ),
                      InputField(
                        hintText: "Designation",
                        prefixIcon: const Icon(Icons.computer),
                        onChanged: (val) {
                          signUpBloc
                              .add(DesignationChangeEvent(designation: val));
                        },
                        textInputAction: TextInputAction.done,
                      ),
                      if (state is AdminSignupEmpty)
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 42,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF38C8C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            "Empty Fields",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      if (state is AdminSignupExists)
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 42,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFFF5F5F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            "User already exists",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      if (state is AdminSignupPasswordFormatError)
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 42,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFFFA52F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            "Password must be atleast 8 characters",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      const SizedBox(
                        height: 8,
                      ),
                      state is AdminSignupLoading
                          ? const BigButtonLoading()
                          : BigButton(
                              title: "Register",
                              onPressed: () {
                                signUpBloc.add(AdminSignup());
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
