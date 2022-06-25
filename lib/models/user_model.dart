// ignore_for_file: non_constant_identifier_names

class User {
  int? user_id;
  String? user_name;
  String? email;
  String? creation_date;
  String? photo;

  User(
      {this.user_id,
      this.user_name,
      this.email,
      this.creation_date,
      this.photo});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      user_id: json["user_id"],
      user_name: json["user_name"],
      email: json["email"],
      creation_date: json["creation_date"],
      photo: json["photo"],
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
  String? photo;
  String? occupation_area;

  UserCreateAccount(
      {this.password,
      this.email,
      this.user_name,
      this.photo,
      this.occupation_area});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'email': email.toString(),
      'password': password.toString(),
      'user_name': user_name.toString(),
      'photo': photo.toString(),
      'occupation_area': occupation_area.toString(),
    };
    return map;
  }
}

class UserAvatar {
  final String id;
  final String photoUrl;
  final String photoName;

  UserAvatar(
      {required this.id, required this.photoUrl, required this.photoName});

  @override
  String toString() => photoName;

  @override
  operator ==(o) => o is UserAvatar && o.photoName == photoName;

  @override
  int get hashCode => id.hashCode ^ photoName.hashCode ^ photoUrl.hashCode;
}

class UserUpdatePhotoDto {
  String? photo;

  UserUpdatePhotoDto({
        this.photo});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'photo': photo.toString(),
    };
    return map;
  }
}
