import 'dart:io';

import 'package:flutter_application_1/models/services_model.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../global_variable.dart';

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
      throw Exception('Failed to load service');
    }
  }
}
