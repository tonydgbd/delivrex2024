// To parse this JSON data, do
//
//     final policyModel = policyModelFromJson(jsonString);

import 'dart:convert';

PolicyModel policyModelFromJson(String str) => PolicyModel.fromJson(json.decode(str));

String policyModelToJson(PolicyModel data) => json.encode(data.toJson());

class PolicyModel {
  PolicyModel({
    this.returnPage,
    this.refundPage,
    this.cancellationPage,
  });

  Pages? returnPage;
  Pages? refundPage;
  Pages? cancellationPage;

  factory PolicyModel.fromJson(Map<String, dynamic> json) => PolicyModel(
    returnPage: Pages.fromJson(
      json: json["return_page"],
    ),

    refundPage: Pages.fromJson(
      json: json["refund_page"],
    ),

    cancellationPage: Pages.fromJson(
      json:  json["cancellation_page"],
    ),
  );

  Map<String, dynamic> toJson() => {
    "return_page": returnPage!.toJson(),
    "refund_page": refundPage!.toJson(),
    "cancellation_page": cancellationPage!.toJson(),
  };
}

class Pages {
  Pages({
    this.status,
    this.content,
  });

  bool? status;
  String? content;

  factory Pages.fromJson({
    required Map<String, dynamic> json,

  }) {
    Pages? pages;
    try{
      pages = Pages(
        status: int.tryParse(json["status"].toString()) == 1 ? true : false,
        content: json["content"],

      );

    }catch(e) {
      pages = null;
    }
    return pages!;



  }
  Map<String, dynamic> toJson() => {
    "status": status,
    "content": content,
  };
}
