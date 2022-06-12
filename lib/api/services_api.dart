import 'dart:io';
import 'dart:convert';

import 'package:flutter_application_1/global_variable.dart';
import 'package:flutter_application_1/models/services_model.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class ServicesService {
  Future<List<Service>> get() async {
    var url = Uri.parse('${GlobalApi.url}/servicos');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    http.Response response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    return decode(response);
  }

  List<Service> decode(http.Response response) {
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);

      List<Service> servicos = decoded.map<Service>((servicos) {
        return Service.fromJson(servicos);
      }).toList();

      return servicos;
    }
    throw '';
  }

  static Future<Response> deletarService(int id) async {
    var url = Uri.parse('${GlobalApi.url}/servicos/$id');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    final response = await http.delete(
      url,
      headers: headers,
    );

    return response;
  }

  static Future<RespService> getServiceById(int id) async {
    var url = Uri.parse('${GlobalApi.url}/servicos/$id');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      var service = RespService.fromJson(jsonDecode(response.body));
      return service;
    } else {
      throw Exception('Failed to load service:${response.statusCode}');
    }
  }

  static Future<Response> createService(ServiceCreate service) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    var body = jsonEncode(service);

    var url = Uri.parse('${GlobalApi.url}/servicos');
    var response2 = await http.post(
      url,
      headers: headers,
      body: body,
    );
    final response = response2;

    return response;
  }

  static Future<Response> updateService(int id, RespService bodyRequest) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    var json = jsonEncode(bodyRequest);
    var body = json;

    var requeste = await http.put(
      Uri.parse('${GlobalApi.url}/servicos/$id'),
      headers: headers,
      body: body,
    );

    final response = requeste;
    print(response.body);

    return response;
  }
}
