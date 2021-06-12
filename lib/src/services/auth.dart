import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meditop_go/src/models/user.dart';
import 'dio.dart';

enum AuthStatus{ Uninitialized, Authenticated, Unauthenticated }

class Auth extends ChangeNotifier {
  AuthStatus _status = AuthStatus.Uninitialized;
  User? _user;
  String? _token;

  AuthStatus get status => _status;
  User? get user => _user;

  final storage = FlutterSecureStorage();

  Auth.instance();

  Future<bool> register({Map? creds}) async {
    try {
      Dio.Response response = await dio().post('/register/user', data: creds);
      print(response.data.toString());
      String token = response.data['token'].toString();
      tryGetToken(token: token);
      return true;
    } catch (exception) {
      print("-----------------ERROR REGISTER POST ---------------");
      return false;
    }
  }

  Future<bool> login({Map? creds}) async {
    try {
      Dio.Response response = await dio().post('/login', data: creds);
      print('RESPONSE DATA LOGIN');
      print(response.data.toString());
      String token = response.data['token'].toString();
      tryGetToken(token: token);
      return true;
    } catch (exception) {
      print("-----------------ERROR LOGIN POST ---------------");
      print(exception);
      return false;
    }
  }

  Future<bool> tryGetToken({String? token}) async {
    if (token == null) {
      _status = AuthStatus.Unauthenticated;
      notifyListeners();
      return false;
    }
    try {
      Dio.Response response = await dio().get('/user',
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      this._user = User.fromJson(response.data);
      this._token = token;
      this._status = AuthStatus.Authenticated;
      await storeToken(token: token);
      notifyListeners();
      print(_user.toString());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future storeToken({required String token}) async {
    storage.write(key: 'token', value: token);
  }

  Future<bool> logout() async {
    try {
      Dio.Response response = await dio().delete('/logout',
          options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));
      print(response.data);
      cleanUp();
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void cleanUp() async {
    this._user = null;
    this._token = null;
    this._status = AuthStatus.Unauthenticated;
    await storage.delete(key: 'token');
  }
}
