// To parse this JSON data, do
//
//     final attendanceHistory = attendanceHistoryFromJson(jsonString);

import 'dart:convert';

AttendanceHistory attendanceHistoryFromJson(String str) =>
    AttendanceHistory.fromJson(json.decode(str));

String attendanceHistoryToJson(AttendanceHistory data) =>
    json.encode(data.toJson());

class AttendanceHistory {
  List<Attendance>? attendances;

  AttendanceHistory({
    this.attendances,
  });

  factory AttendanceHistory.fromJson(Map<String, dynamic> json) =>
      AttendanceHistory(
        attendances: json["attendances"] == null
            ? []
            : List<Attendance>.from(
                json["attendances"]!.map((x) => Attendance.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "attendances": attendances == null
            ? []
            : List<dynamic>.from(attendances!.map((x) => x.toJson())),
      };
}

class Attendance {
  In? attendanceIn;
  Out? out;
  String? id;
  String? email;
  String? lastScan;
  int? v;

  Attendance({
    this.attendanceIn,
    this.out,
    this.id,
    this.email,
    this.lastScan,
    this.v,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
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
