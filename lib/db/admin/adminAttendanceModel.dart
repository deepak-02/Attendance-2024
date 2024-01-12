// To parse this JSON data, do
//
//     final adminAttendanceModel = adminAttendanceModelFromJson(jsonString);

import 'dart:convert';

AdminAttendanceModel adminAttendanceModelFromJson(String str) => AdminAttendanceModel.fromJson(json.decode(str));

String adminAttendanceModelToJson(AdminAttendanceModel data) => json.encode(data.toJson());

class AdminAttendanceModel {
  List<Attendance>? attendances;

  AdminAttendanceModel({
    this.attendances,
  });

  factory AdminAttendanceModel.fromJson(Map<String, dynamic> json) => AdminAttendanceModel(
    attendances: json["attendances"] == null ? [] : List<Attendance>.from(json["attendances"]!.map((x) => Attendance.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "attendances": attendances == null ? [] : List<dynamic>.from(attendances!.map((x) => x.toJson())),
  };
}

class Attendance {
  In? attendanceIn;
  Out? out;
  String? id;
  String? email;
  String? name;
  String? phone;
  String? address;
  String? designation;
  String? batch;
  String? lastScan;
  String? image;
  String? createdAt;
  String? updatedAt;
  int? v;

  Attendance({
    this.attendanceIn,
    this.out,
    this.id,
    this.email,
    this.name,
    this.phone,
    this.address,
    this.designation,
    this.batch,
    this.lastScan,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
    attendanceIn: json["in"] == null ? null : In.fromJson(json["in"]),
    out: json["out"] == null ? null : Out.fromJson(json["out"]),
    id: json["_id"],
    email: json["email"],
    name: json["name"],
    phone: json["phone"],
    address: json["address"],
    designation: json["designation"],
    batch: json["batch"],
    lastScan: json["lastScan"],
    image: json["image"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "in": attendanceIn?.toJson(),
    "out": out?.toJson(),
    "_id": id,
    "email": email,
    "name": name,
    "phone": phone,
    "address": address,
    "designation": designation,
    "batch": batch,
    "lastScan": lastScan,
    "image": image,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "__v": v,
  };
}

class In {
  String? date;
  String? time;
  bool? late;

  In({
    this.date,
    this.time,
    this.late,
  });

  factory In.fromJson(Map<String, dynamic> json) => In(
    date: json["date"],
    time: json["time"],
    late: json["late"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "time": time,
    "late": late,
  };
}

class Out {
  String? date;
  String? time;

  Out({
    this.date,
    this.time,
  });

  factory Out.fromJson(Map<String, dynamic> json) => Out(
    date: json["date"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "time": time,
  };
}
