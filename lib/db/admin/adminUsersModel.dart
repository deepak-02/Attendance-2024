// To parse this JSON data, do
//
//     final adminUsersModel = adminUsersModelFromJson(jsonString);

import 'dart:convert';

List<AdminUsersModel> adminUsersModelFromJson(String str) =>
    List<AdminUsersModel>.from(
        json.decode(str).map((x) => AdminUsersModel.fromJson(x)));

String adminUsersModelToJson(List<AdminUsersModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AdminUsersModel {
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
  String? image;

  AdminUsersModel({
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
    this.image,
  });

  factory AdminUsersModel.fromJson(Map<String, dynamic> json) =>
      AdminUsersModel(
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
        image: json["image"],
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
        "image": image,
      };
}
