import 'package:attendance/blocs/attendanceBloc/attendance_bloc.dart';
import 'package:attendance/blocs/loginBloc/login_bloc.dart';
import 'package:attendance/screens/home/dashboard.dart';
import 'package:attendance/screens/login/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/homeBloc/home_bloc.dart';
import 'blocs/leaveBloc/leave_bloc.dart';
import 'blocs/profileBloc/profile_bloc.dart';
import 'blocs/resetPasswordBloc/reset_password_bloc.dart';
import 'blocs/signUpBloc/sign_up_bloc.dart';
import 'db/firebaseApi.dart';

dynamic email;
final navigatorKey = GlobalKey<NavigatorState>();
 main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  SharedPreferences prefs = await SharedPreferences.getInstance();
  email = prefs.getString('email');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(),
        ),
        BlocProvider<SignUpBloc>(
          create: (context) => SignUpBloc(),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(),
        ),
        BlocProvider<AttendanceBloc>(
          create: (context) => AttendanceBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(),
        ),
        BlocProvider<LeaveBloc>(
          create: (context) => LeaveBloc(),
        ),
        BlocProvider<ResetPasswordBloc>(
          create: (context) => ResetPasswordBloc(),
        ),
      ],
      child: GetMaterialApp(
        navigatorKey: navigatorKey,
        title: 'Attendance',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: Colors.deepPurple), //#6f42c0
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 0,
              shadowColor: Colors.transparent),
          useMaterial3: true,
        ),
        home: email == null || email == ""
            ? const LoginPage()
            : const Dashboard(),
      ),
    );
  }
}
