import 'package:myapp/data/models/user_model.dart';

class LoginModel {
  String? status;
  UserModel? userData;
  String? token;

  LoginModel({this.status, this.userData, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userData = json['data'] != null ? UserModel.fromJson(json['data']) : null;
    token = json['token'];
  }
}
