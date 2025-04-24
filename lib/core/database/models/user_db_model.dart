import 'dart:convert';

UserDbModel userFromJson(String str) => UserDbModel.fromJson(json.decode(str));

String userToJson(UserDbModel data) => json.encode(data.toJson());

class UserDbModel {
  //nombres de las columnas de la tabla
  static const String table = 'user';
  static const String columnId = 'id';
  static const String columnUserName = 'username';
  static const String columnEmain = 'email';
  static const String columnPassword = 'password';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';

  final String id;
  final String username;
  final String email;
  final String password;
  final String createdAt;
  final String updatedAt;

  UserDbModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
  });

  UserDbModel copyWith({
    String? id,
    String? username,
    String? email,
    String? password,
    String? createdAt,
    String? updatedAt,
  }) =>
      UserDbModel(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory UserDbModel.fromJson(Map<String, dynamic> json) => UserDbModel(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "password": password,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
