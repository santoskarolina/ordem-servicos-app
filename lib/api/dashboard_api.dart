import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../global_variable.dart';
import '../models/dashboard_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashbpardApi {
  
  static Future<ClienteReport> getClientReport() async {
     var url = Uri.parse('${GlobalApi.url}/clientes/servicos/relatorios');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    final response = await http.get(
      url,
     headers: headers
    );
    if (response.statusCode == 200) {
      var client = ClienteReport.fromJson(jsonDecode(response.body));
      return client;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  static Future<ServiceReport> getServiceReport() async {
    var url = Uri.parse('${GlobalApi.url}/servicos/todos/report');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    final response = await http.get(
      url,
      headers: headers
    );
    if (response.statusCode == 200) {
      var service = ServiceReport.fromJson(jsonDecode(response.body));
      return service;
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
