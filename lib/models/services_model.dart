// ignore_for_file: non_constant_identifier_names

// import 'dart:convert';

import 'client_model.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Service {
  int service_id;
  final String description;
  Cliente? client;
  final Status status;
  final String price;
  final String opening_date;
  final String? closing_date;

  Service(this.service_id, this.description, this.status,
      this.closing_date, this.opening_date, this.price);

  Service.fromJson(Map<String, dynamic> json) 
      : service_id = json["service_id"],
        description = json["description"],
        status = Status.fromJson(json['status']),
        price = json["price"],
        closing_date = json["closing_date"],
        opening_date = json["opening_date"];
}

class Status {
  int? status_id;
  String? name;
  int? code;

  Status({this.status_id, this.name, this.code});

  factory  Status.fromJson(Map<String, dynamic> json) {
    return Status(
      status_id: json['status_id'],
      name: json['name'],
      code: json['code'],
    );
  }
}

class RespService {
  final int service_id;
  final String description;
  final RespCliente client;
  final Status status;
  final String price;
  final String opening_date;
  final String? closing_date;

  RespService(this.service_id, this.description, this.status,
      this.closing_date, this.client, this.opening_date, this.price);

  RespService.fromJson(Map<String, dynamic> json) 
      : service_id = json["service_id"],
        description = json["description"],
        status = Status.fromJson(json['status']),
        client = RespCliente.fromJson(json['client']),
        price = json["price"],
        closing_date = json["closing_date"],
        opening_date = json["opening_date"];
}