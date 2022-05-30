// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'dart:convert';

import 'package:flutter_application_1/global_variable.dart';
import 'package:http/http.dart';

import '../models/client_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ClienteService {
  var url = Uri.parse('${GlobalApi.url}/clientes');

  Future<List<RespCliente>> get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    http.Response response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });
    return decode(response);
  }

  List<RespCliente> decode(http.Response response) {
    if (response.statusCode == 200) {
      var decoded = jsonDecode(response.body);

      List<RespCliente> clientes = decoded.map<RespCliente>((clientes) {
        return RespCliente.fromJson(clientes);
      }).toList();

      return clientes;
    } else {}
    throw response.statusCode;
  }

  static Future<Response> createCliente(String name, String cpf, String cell_phone) async {
    var url = Uri.parse('${GlobalApi.url}/clientes/');

    var data = jsonEncode(
        <String, dynamic>{'name': name, 'cpf': cpf, 'cell_phone': cell_phone});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    final response = await http.post(
      url,
      headers: headers,
      body: data,
    );

    return response;
  }

  static Future<Response> deletarCliente(int cliente_id) async {
    var url = Uri.parse('${GlobalApi.url}/clientes/$cliente_id');

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

  static Future<IRespCliente> getClientById(int id) async {
    var url = Uri.parse('${GlobalApi.url}/clientes/$id');
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
      var client = IRespCliente.fromJson(jsonDecode(response.body));
      return client;
    } else {
      throw Exception('Failed to load client');
    }
  }

  static Future<Response> updateCliente(int? id, IRespCliente body) async {
    var url = Uri.parse('${GlobalApi.url}/clientes/$id');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    final response = await http.put(
      url,
      headers: headers,
      body: body.toJson()
    );

    return response;
  }
}
