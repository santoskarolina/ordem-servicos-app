// ignore_for_file: non_constant_identifier_names

class User {
  int? user_id;
  String? user_name;
  String? email;
  String? creation_date;

   User({this.user_id, this.user_name, this.email, this.creation_date});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      user_id: json["user_id"],
      user_name: json["user_name"],
      email: json["email"],
      creation_date: json["creation_date"],
    );
  }
}

class LoginResponse {
  String? access_token;

  LoginResponse({this.access_token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      access_token: json["access_token"],
    );
  }
}

class UserRequest {
  String? email;
  String? password;

  UserRequest({this.password, this.email});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'email': email.toString(),
      'password': password.toString()
    };
    return map;
  }
}

class UserCreateAccount {
  String? user_name;
   String? email;
  String? password;

  UserCreateAccount({this.password, this.email, this.user_name});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'email': email.toString(),
      'password': password.toString(),
      'user_name': user_name.toString(),
    };
    return map;
  }
}
