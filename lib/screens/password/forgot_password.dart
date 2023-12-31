import 'package:attendance/screens/password/varify_o_t_p.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as nav;
import 'package:lottie/lottie.dart';
import '../../blocs/resetPasswordBloc/reset_password_bloc.dart';
import '../../widgets/big_button.dart';
import '../../widgets/input_field.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final passwordBloc = context.read<ResetPasswordBloc>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
          listener: (context, state) {
            if (state is SendOtpSuccessState) {
              Fluttertoast.showToast(
                  msg: 'Email Send',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: const Color(0x3F000000),
                  textColor: Colors.white,
                  fontSize: 16.0);

              nav.Get.to(
                VerifyOTP(
                  email: emailController.text,
                ),
                transition: nav.Transition.rightToLeft,
                duration: const Duration(milliseconds: 800),
              );
            } else if (state is SendOtpErrorState) {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    const Padding(
                      padding: EdgeInsets.only(left: 14),
                      child: Text(
                        "Reset Password",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 40,
                            color: Colors.black),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 14),
                      child: Text(
                        "Enter your email associated with your account and we'll send an email with the OTP to reset your password.",
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                            color: Colors.black45),
                      ),
                    ),
                    Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Lottie.asset('assets/lottie/sloth.json')),
                    ),
                    const Spacer(),
                    InputField(
                      hintText: "Email",
                      labelText: "Email",
                      controller: emailController,
                      prefixIcon: const Icon(Icons.alternate_email),
                      onChanged: (val) {
                        // passwordBloc.add(EmailChangeEvent(email: val));
                      },
                      textCapitalization: TextCapitalization.none,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    if (state is UserNotFoundState)
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
                          "User does not exists",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    state is SendOtpLoadingState
                        ? const BigButtonLoading()
                        : BigButton(
                            title: "Next",
                            onPressed: () {
                              passwordBloc.add(
                                  SendOTPEvent(email: emailController.text));
                            },
                          ),
                    const Spacer(),
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
