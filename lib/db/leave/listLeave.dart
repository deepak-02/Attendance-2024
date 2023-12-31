// To parse this JSON data, do
//
//     final listLeaveModel = listLeaveModelFromJson(jsonString);

import 'dart:convert';

ListLeaveModel listLeaveModelFromJson(String str) =>
    ListLeaveModel.fromJson(json.decode(str));

String listLeaveModelToJson(ListLeaveModel data) => json.encode(data.toJson());

class ListLeaveModel {
  List<LeaveRequest>? leaveRequests;

  ListLeaveModel({
    this.leaveRequests,
  });

  factory ListLeaveModel.fromJson(Map<String, dynamic> json) => ListLeaveModel(
        leaveRequests: json["leaveRequests"] == null
            ? []
            : List<LeaveRequest>.from(
                json["leaveRequests"]!.map((x) => LeaveRequest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "leaveRequests": leaveRequests == null
            ? []
            : List<dynamic>.from(leaveRequests!.map((x) => x.toJson())),
      };
}

class LeaveRequest {
  String? leaveId;
  String? email;
  String? requestDate;
  String? toDate;
  String? type;
  String? reason;
  String? requestStatus;
  String? requestedOn;
  String? approvedOrRejectedOn;
  String? name;

  LeaveRequest({
    this.leaveId,
    this.email,
    this.requestDate,
    this.toDate,
    this.type,
    this.reason,
    this.requestStatus,
    this.requestedOn,
    this.approvedOrRejectedOn,
    this.name,
  });

  factory LeaveRequest.fromJson(Map<String, dynamic> json) => LeaveRequest(
        leaveId: json["leaveId"],
        email: json["email"],
        requestDate: json["requestDate"],
        toDate: json["toDate"],
        type: json["type"],
        reason: json["reason"],
        requestStatus: json["requestStatus"],
        requestedOn: json["requestedOn"],
        approvedOrRejectedOn: json["approvedOrRejectedOn"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "leaveId": leaveId,
        "email": email,
        "requestDate": requestDate,
        "toDate": toDate,
        "type": type,
        "reason": reason,
        "requestStatus": requestStatus,
        "requestedOn": requestedOn,
        "approvedOrRejectedOn": approvedOrRejectedOn,
        "name": name,
      };
}
