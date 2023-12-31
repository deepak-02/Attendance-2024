import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../db/api.dart';
import '../../db/profile/profileDetails.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  String name = '';
  String phone = '';
  String address = '';
  String batch = '';
  String designation = '';
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) {});

    on<GetProfileEvent>((event, emit) async {
      try {
        emit(GetProfileLoadingState());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String email = prefs.getString('email')!;
        final response = await http.get(
          Uri.parse('${api}user/get/$email'),
          headers: {"content-type": "application/json"},
        );
        if (response.statusCode == 200) {
          final data = profileDetailsModelFromJson(response.body);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("name", data.user!.name!);
          emit(GetProfileSuccessState(user: data.user));
        } else {
          emit(GetProfileErrorState(error: response.body));
        }
      } catch (e) {
        print(e);
        emit(GetProfileErrorState(error: e.toString()));
      }
    });

    on<GetProfileImageEvent>((event, emit) async {
      try {
        emit(GetProfileImageLoadingState());
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
          emit(GetProfileImageSuccessState(
              image: responseData['image']['data']));
        } else if (response.statusCode == 404) {
          emit(GetProfileImageNotFoundState());
        } else {
          emit(GetProfileImageErrorState(error: response.body));
        }
      } catch (e) {
        emit(GetProfileImageErrorState(error: e.toString()));
      }
    });

    on<NameChangeEvent>((event, emit) {
      name = event.name;
    });
    on<PhoneChangeEvent>((event, emit) {
      phone = event.phone;
    });
    on<AddressChangeEvent>((event, emit) {
      address = event.address;
    });
    on<BatchChangeEvent>((event, emit) {
      batch = event.batch;
    });
    on<DesignationChangeEvent>((event, emit) {
      designation = event.designation;
    });

    on<RemoveProfileImageEvent>((event, emit) async {
      try {
        emit(RemoveProfileImageLoadingState());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String email = prefs.getString('email')!;
        final response = await http.get(
          Uri.parse('${api}user/image-delete/$email'),
          headers: {"content-type": "application/json"},
        );
        if (response.statusCode == 200) {
          emit(RemoveProfileImageSuccessState());
        } else if (response.statusCode == 404) {
          emit(GetProfileImageNotFoundState());
        } else {
          emit(RemoveProfileImageErrorState(error: response.body));
        }
      } catch (e) {
        print(e);
        emit(RemoveProfileImageErrorState(error: e.toString()));
      }
    });

    on<UploadProfileImageEvent>((event, emit) async {
      try {
        emit(UploadProfileImageLoadingState());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String email = prefs.getString('email')!;

        final request = http.MultipartRequest(
          'POST',
          Uri.parse('${api}user/image-add'),
        );

        final imgFile = File(event.image.path);
        final stream = http.ByteStream(imgFile.openRead());
        final length = await imgFile.length();
        final file = http.MultipartFile(
          'image',
          stream,
          length,
          filename: imgFile.path.split('/').last,
        );
        request.fields['email'] = email;
        request.files.add(file);

        // Send the request
        final response = await request.send();
        print(response.statusCode);
        if (response.statusCode == 200) {
          emit(UploadProfileImageSuccessState());
        } else {
          emit(UploadProfileImageErrorState(
              error: response.reasonPhrase.toString()));
        }
      } catch (e) {
        print(e.toString());
        emit(UploadProfileImageErrorState(error: e.toString()));
      }
    });
    on<UpdateProfileEvent>((event, emit) async {
      try {
        emit(UpdateProfileLoadingState());
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String email = prefs.getString('email')!;
        final response = await http.post(
          Uri.parse('${api}user/update'),
          body: jsonEncode({
            "name": name,
            "email": email,
            "phoneNumber": phone,
            "address": address,
            "batch": batch,
            "designation": designation
          }),
          headers: {"content-type": "application/json"},
        );
        if (response.statusCode == 200) {
          // Map<String, dynamic> responseData = json.decode(response.body);
          emit(UpdateProfileSuccessState());
        } else {
          emit(UpdateProfileErrorState(error: response.body));
        }
      } catch (e) {
        emit(UpdateProfileErrorState(error: e.toString()));
      }
    });
  }
}
