// To parse this JSON data, do
//
//     final currentAttendance = currentAttendanceFromJson(jsonString);

import 'dart:convert';

CurrentAttendance currentAttendanceFromJson(String str) =>
    CurrentAttendance.fromJson(json.decode(str));

String currentAttendanceToJson(CurrentAttendance data) =>
    json.encode(data.toJson());

class CurrentAttendance {
  List<AttendanceElement>? attendances;

  CurrentAttendance({
    this.attendances,
  });

  factory CurrentAttendance.fromJson(Map<String, dynamic> json) =>
      CurrentAttendance(
        attendances: json["attendances"] == null
            ? []
            : List<AttendanceElement>.from(
                json["attendances"]!.map((x) => AttendanceElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "attendances": attendances == null
            ? []
            : List<dynamic>.from(attendances!.map((x) => x.toJson())),
      };
}

class AttendanceElement {
  AttendanceAttendance? attendance;
  String? name;
  String? image;

  AttendanceElement({
    this.attendance,
    this.name,
    this.image,
  });

  factory AttendanceElement.fromJson(Map<String, dynamic> json) =>
      AttendanceElement(
        attendance: json["attendance"] == null
            ? null
            : AttendanceAttendance.fromJson(json["attendance"]),
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "attendance": attendance?.toJson(),
        "name": name,
        "image": image,
      };
}

class AttendanceAttendance {
  In? attendanceIn;
  Out? out;
  String? id;
  String? email;
  String? lastScan;
  int? v;

  AttendanceAttendance({
    this.attendanceIn,
    this.out,
    this.id,
    this.email,
    this.lastScan,
    this.v,
  });

  factory AttendanceAttendance.fromJson(Map<String, dynamic> json) =>
      AttendanceAttendance(
        attendanceIn: json["in"] == null ? null : In.fromJson(json["in"]),
        out: json["out"] == null ? null : Out.fromJson(json["out"]),
        id: json["_id"],
        email: json["email"],
        lastScan: json["lastScan"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "in": attendanceIn?.toJson(),
        "out": out?.toJson(),
        "_id": id,
        "email": email,
        "lastScan": lastScan,
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
