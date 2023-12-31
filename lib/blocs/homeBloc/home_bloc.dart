import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../db/api.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {});

    on<GetAttendanceStatus>((event, emit) async {
      try {
        emit(AttendanceStatusLoading());
        SharedPreferences prefs = await SharedPreferences.getInstance();

        String email = prefs.getString('email')!;

        final response = await http.get(
          Uri.parse('${api}attendance/getStatus/$email'),
          headers: {"content-type": "application/json"},
        );
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          emit(AttendanceStatusSuccess(status: data['status']));
        } else {
          emit(AttendanceStatusError());
        }
      } catch (e) {
        print(e);
        emit(AttendanceStatusError());
      }
    });

    on<GetProfileImage>((event, emit) async {
      try {
        emit(GetProfileImageLoading());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String email = prefs.getString('email')!;

        final response = await http.post(
          Uri.parse('${api}user/image-get'),
          body: jsonEncode({
            "email": email,
          }),
          headers: {"content-type": "application/json"},
        );
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = json.decode(response.body);
          emit(GetProfileImageSuccess(image: responseData['image']['data']));

          // setState(() {
          //   imageUrl = responseData['image']['data'];
          // contentType = responseData['image']['contentType'];
          // email = responseData['image']['email'];
          // });
        } else if (response.statusCode == 404) {
          emit(GetProfileImageNotFound());
        } else {
          emit(GetProfileImageError());
        }
      } catch (e) {
        print(e);
        emit(GetProfileImageError());
      }
    });

    on<MarkAttendance>((event, emit) async {
      try {
        if (event.lastScan == 'in') {
          emit(MarkInAttendanceLoading());
        } else {
          emit(MarkOutAttendanceLoading());
        }
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String email = prefs.getString('email')!;

        final response = await http.post(
          Uri.parse('${api}qr/verify'),
          body: jsonEncode({
            "qrCode": event.qrCode,
            "email": email,
            "lastScan": event.lastScan
          }),
          headers: {"content-type": "application/json"},
        );
        if (response.statusCode == 200) {
          emit(MarkAttendanceSuccess());
        } else if (response.statusCode == 202) {
          Map<String, dynamic> responseData = json.decode(response.body);
          emit(MarkAttendanceInvalid(message: responseData['message']));
        } else {
          emit(MarkAttendanceError());
        }
      } catch (e) {
        print(e);
        emit(MarkAttendanceError());
      }
    });
  }
}
