import 'dart:async';

import 'package:attendance/screens/password/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as nav;
import 'package:lottie/lottie.dart';

import '../../blocs/resetPasswordBloc/reset_password_bloc.dart';
import '../../widgets/big_button.dart';
import '../../widgets/input_field.dart';

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({super.key, required this.email});
  final String email;
  @override
  _VerifyOTPState createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  Timer? _timer;
  int _coolDown = 60;
  bool _isButtonDisabled = false;

  TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final passwordBloc = context.read<ResetPasswordBloc>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
          listener: (context, state) {
            if (state is VerifyOtpSuccessState) {
              nav.Get.to(
                const ResetPasswordPage(),
                transition: nav.Transition.rightToLeft,
                duration: const Duration(milliseconds: 800),
              );
            } else if (state is VerifyOtpInvalidState) {
              Fluttertoast.showToast(
                  msg: "Invalid OTP!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: const Color(0x3F000000),
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else if (state is SendOtpSuccessState) {
              Fluttertoast.showToast(
                  msg: "Email send",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: const Color(0x3F000000),
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else if (state is SendOtpErrorState) {
              forceResetCooldown();
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
                          child: Lottie.asset('assets/lottie/email.json')),
                    ),

                    const Text(
                      "Verify OTP",
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 40,
                          color: Colors.black),
                    ),
                    const Text(
                      "Enter the OTP send to your email address.",
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                          color: Colors.black45),
                    ),
                    Text(
                      widget.email,
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),

                    const Spacer(),
                    InputField(
                      hintText: "OTP",
                      labelText: "OTP",
                      controller: otpController,
                      prefixIcon: const Icon(Icons.messenger_outline),
                      onChanged: (val) {},
                      textCapitalization: TextCapitalization.none,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        // LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                    if (state is EmptyFieldState)
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
                          "OTP is required",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                    const SizedBox(
                      height: 10,
                    ),

                    state is VerifyOtpLoadingState
                        ? const BigButtonLoading()
                        : BigButton(
                            title: "Verify",
                            onPressed: () {
                              passwordBloc.add(OTPVerifyEvent(
                                  widget.email, otpController.text));
                            },
                          ),
                    const Spacer(),
                    const Text(
                      "Did not receive the email? Check your spam filter.",
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: Colors.black54),
                    ),
                    const Text(
                      "- OR -",
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: Colors.black),
                    ),
                    TextButton(
                        onPressed: _isButtonDisabled ? null : () => sendOtp(),
                        child: Text(
                          _isButtonDisabled
                              ? 'Resend in ($_coolDown)'
                              : 'Resend OTP',
                        ))
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

  void startCooldown() {
    //sendOtp();
    _isButtonDisabled = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_coolDown > 0) {
          _coolDown--;
        } else {
          _timer?.cancel();
          _isButtonDisabled = false;
        }
      });
    });
  }

  void forceResetCooldown() {
    _timer?.cancel();
    setState(() {
      _coolDown = 60;
      _isButtonDisabled = false;
    });
  }

  sendOtp() {
    BlocProvider.of<ResetPasswordBloc>(context)
        .add(SendOTPEvent(email: widget.email));
    startCooldown();
  }
}
