import 'package:attendance/screens/home/dashboard.dart';
import 'package:attendance/screens/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as nav;
import 'package:lottie/lottie.dart';

import '../../blocs/resetPasswordBloc/reset_password_bloc.dart';
import '../../widgets/big_button.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, this.page});
  final String? page;
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool obSecure = true;

  @override
  Widget build(BuildContext context) {
    final passwordBloc = context.read<ResetPasswordBloc>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
          listener: (context, state) {
            if (state is ResetPasswordSuccessState) {
              Fluttertoast.showToast(
                  msg: "Password Reset Successful",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: const Color(0x3F000000),
                  textColor: Colors.white,
                  fontSize: 16.0);

              if (widget.page == 'profile') {
                nav.Get.offAll(
                  const Dashboard(),
                  transition: nav.Transition.rightToLeft,
                  duration: const Duration(milliseconds: 800),
                );
              } else {
                nav.Get.offAll(
                  const LoginPage(),
                  transition: nav.Transition.rightToLeft,
                  duration: const Duration(milliseconds: 800),
                );
              }
            } else if (state is ResetPasswordErrorState) {
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
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          tooltip: "back",
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            nav.Get.back();
                          },
                        ),
                      ],
                    ),

                    Expanded(
                      child: Align(
                          alignment: Alignment.center,
                          child: Lottie.asset('assets/lottie/password.json')),
                    ),

                    const Text(
                      "Reset Password",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 40,
                          color: Colors.black),
                    ),
                    const Text(
                      "You can reset your password now. Make sure you remember it now or you ca reset it again & again",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        color: Colors.black45,
                      ),
                    ),

                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        onChanged: (val) {
                          passwordBloc.add(PasswordChangeEvent(password: val));
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          hintText: 'Password',
                          prefixIcon: const Icon(Icons.key),
                          suffixIcon: IconButton(
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
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        onChanged: (val) {
                          passwordBloc.add(
                              ConfirmPasswordChangeEvent(confirmPassword: val));
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          hintText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.key),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        obscureText: obSecure,
                      ),
                    ),

                    if (state is ResetPasswordFormatErrorState)
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
                          "Password must be at least 8 characters",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                    if (state is ResetPasswordMissMatchState)
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
                          "Password Miss Match!",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    const SizedBox(
                      height: 10,
                    ),

                    state is ResetPasswordLoadingState
                        ? const BigButtonLoading()
                        : BigButton(
                            title: "Reset",
                            onPressed: () {
                              passwordBloc.add(ResetPasswordBtnClickEvent());
                            },
                          ),
                    const Spacer(),

                    // const Spacer(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
