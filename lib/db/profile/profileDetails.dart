// To parse this JSON data, do
//
//     final profileDetailsModel = profileDetailsModelFromJson(jsonString);

import 'dart:convert';

ProfileDetailsModel profileDetailsModelFromJson(String str) =>
    ProfileDetailsModel.fromJson(json.decode(str));

String profileDetailsModelToJson(ProfileDetailsModel data) =>
    json.encode(data.toJson());

class ProfileDetailsModel {
  User? user;

  ProfileDetailsModel({
    this.user,
  });

  factory ProfileDetailsModel.fromJson(Map<String, dynamic> json) =>
      ProfileDetailsModel(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
      };
}

class User {
  String? id;
  String? userId;
  String? name;
  String? email;
  String? role;
  String? address;
  String? phoneNumber;
  String? batch;
  String? designation;
  String? createdAt;
  String? updatedAt;
  int? v;

  User({
    this.id,
    this.userId,
    this.name,
    this.email,
    this.role,
    this.address,
    this.phoneNumber,
    this.batch,
    this.designation,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        userId: json["userId"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        address: json["address"],
        phoneNumber: json["phoneNumber"],
        batch: json["batch"],
        designation: json["designation"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "name": name,
        "email": email,
        "role": role,
        "address": address,
        "phoneNumber": phoneNumber,
        "batch": batch,
        "designation": designation,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
      };
}
