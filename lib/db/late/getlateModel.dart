// To parse this JSON data, do
//
//     final getLateModel = getLateModelFromJson(jsonString);

import 'dart:convert';

GetLateModel getLateModelFromJson(String str) =>
    GetLateModel.fromJson(json.decode(str));

String getLateModelToJson(GetLateModel data) => json.encode(data.toJson());

class GetLateModel {
  List<LateRequest>? lateRequests;

  GetLateModel({
    this.lateRequests,
  });

  factory GetLateModel.fromJson(Map<String, dynamic> json) => GetLateModel(
        lateRequests: json["lateRequests"] == null
            ? []
            : List<LateRequest>.from(
                json["lateRequests"]!.map((x) => LateRequest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "lateRequests": lateRequests == null
            ? []
            : List<dynamic>.from(lateRequests!.map((x) => x.toJson())),
      };
}

class LateRequest {
  String? lateId;
  String? email;
  String? on;
  String? reason;
  String? requestStatus;
  String? requestMethod;
  String? requestedOn;
  bool? willLate;
  String? name;

  LateRequest({
    this.lateId,
    this.email,
    this.on,
    this.reason,
    this.requestStatus,
    this.requestMethod,
    this.requestedOn,
    this.willLate,
    this.name,
  });

  factory LateRequest.fromJson(Map<String, dynamic> json) => LateRequest(
        lateId: json["lateId"],
        email: json["email"],
        on: json["on"],
        reason: json["reason"],
        requestStatus: json["requestStatus"],
        requestMethod: json["requestMethod"],
        requestedOn: json["requestedOn"],
        willLate: json["willLate"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "lateId": lateId,
        "email": email,
        "on": on,
        "reason": reason,
        "requestStatus": requestStatus,
        "requestMethod": requestMethod,
        "requestedOn": requestedOn,
        "willLate": willLate,
        "name": name,
      };
}
