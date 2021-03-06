// ignore_for_file: non_constant_identifier_names

class UserResponse {
  final int user_id;
  final String user_name;
  final String email;
  final String creation_date;
  final String photo;
  final String occupation_area;

  const UserResponse({
    required this.user_id,
    required this.user_name,
    required this.email,
    required this.creation_date,
    required this.photo,
    required this.occupation_area

  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      user_id: json['user_id'],
      user_name: json['user_name'],
      email: json['email'],
      creation_date: json['creation_date'],
      photo: json['photo'],
      occupation_area: json['occupation_area'],
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': user_id,
        'user_name': user_name,
        'email': email,
        'creation_date': creation_date,
        'photo': photo,
        'occupation_area': occupation_area,
      };
}
