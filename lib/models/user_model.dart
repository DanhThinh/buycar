class UserModel {
  UserModel(
      {required this.id,
      required this.username,
      required this.password,
      required this.email,
      required this.address});

  late String id;
  late String username;
  late String password;
  late String email;
  late String address;

  UserModel.fromMap(Map<String, dynamic> data) {
    id = data["id"];
    username = data["username"];
    password = data["password"];
    email = data["email"];
    address = data["address"];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "password": password,
        "email": email,
        "address": address
      };
}
