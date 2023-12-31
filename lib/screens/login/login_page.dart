import 'package:attendance/blocs/loginBloc/login_bloc.dart';
import 'package:attendance/screens/password/forgot_password.dart';
import 'package:attendance/screens/login/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as nav;
import '../../widgets/big_button.dart';
import '../../widgets/input_field.dart';
import '../home/dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obSecure = true;

  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginErrorState) {
                Fluttertoast.showToast(
                    msg: state.error,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: const Color(0x3F000000),
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else if (state is LoginSuccessState) {
                nav.Get.offAll(
                  const Dashboard(),
                  transition: nav.Transition.circularReveal,
                  duration: const Duration(milliseconds: 800),
                );
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/images/ic_launcher.png'),
                          fit: BoxFit.contain,
                        ),
                        borderRadius: BorderRadius.circular(60.0),
                      ),
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 40,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 6
                            ..color = const Color(0xFF6F42C0),
                        ),
                      ),
                      const Text(
                        'Login',
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
                  const Spacer(),
                  InputField(
                    hintText: "Email",
                    prefixIcon: const Icon(Icons.alternate_email),
                    onChanged: (val) {
                      loginBloc.add(EmailChangeEvent(email: val));
                    },
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      onChanged: (val) {
                        loginBloc.add(PasswordChangeEvent(password: val));
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
                  if (state is EmptyFieldsState)
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
                  if (state is BadCredentialsState)
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
                        "Bad Credentials",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  if (state is NoUserFoundState)
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
                  if (state is PasswordFormatErrorState)
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            nav.Get.to(
                              ForgotPassword(),
                              transition: nav.Transition.rightToLeft,
                              duration: const Duration(milliseconds: 800),
                            );
                          },
                          child: const Text("Forgot Password ?")),
                    ],
                  ),
                  state is LoginLoadingState
                      ? const BigButtonLoading()
                      : BigButton(
                          title: "Login",
                          onPressed: () {
                            loginBloc.add(LoginBtnClickEvent());
                          },
                        ),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        nav.Get.to(
                          const SignUpPage(),
                          transition: nav.Transition.downToUp,
                          duration: const Duration(milliseconds: 800),
                        );
                      },
                      child: const Text("Sign Up")),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
