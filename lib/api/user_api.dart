import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../global_variable.dart';
import '../models/user.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static Future<bool> login(UserRequest userRequest) async {
    var url = Uri.parse('${GlobalApi.url}/auth/login');
    
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.post(
      url,
      body: userRequest.toJson(),
    );
      print(jsonEncode(response.body));
    if (response.statusCode == 201) {
      var accessToken2 = LoginResponse.fromJson(json.decode(response.body)).access_token;
      await prefs.setString('access_token', accessToken2!);

      return true;
    } else {
      return false;
    }
  }

  static Future<Response> createAccount(UserCreateAccount user) async {
    var url = Uri.parse('${GlobalApi.url}/user');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };

    final response = await http.post(
      url,
      body: user.toJson(),
      headers: headers,
    );
    
    return response;
  }


static Future<UserResponse> userProfile() async {
    var url = Uri.parse('${GlobalApi.url}/user/infos');

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
      var client = UserResponse.fromJson(jsonDecode(response.body));
      return client;
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
