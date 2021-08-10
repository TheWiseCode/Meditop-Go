import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meditop_go/src/models/user.dart';
import 'dio.dart';

enum AuthStatus { Uninitialized, Authenticated, Unauthenticated }

class Auth extends ChangeNotifier {
  AuthStatus _status = AuthStatus.Uninitialized;
  User? _user;
  String? _token;

  AuthStatus get status => _status;

  User? get user => _user;

  String? get token => _token;

  final storage = FlutterSecureStorage();

  Auth.instance();

  Future<Response?> register({Map? creds}) async {
    try {
      Dio.Response response = await http().post('/register/user', data: creds);
      print(response.data.toString());
      String token = response.data['token'].toString();
      tryGetToken(token: token);
      return response;
    } on DioError catch (e) {
      print("-----------------ERROR REGISTER POST ---------------");
      return e.response;
    }
  }

  Future<Response?> login({Map? creds}) async {
    try {
      Dio.Response response = await http().post('/login', data: creds);
      print('RESPONSE DATA LOGIN');
      print(response.data.toString());
      String token = response.data['token'].toString();
      tryGetToken(token: token);
      return response;
    } on DioError catch (e) {
      print("-----------------ERROR LOGIN POST ---------------");
      return e.response;
    }
  }

  Future<bool> tryGetToken({String? token}) async {
    if (token == null) {
      _status = AuthStatus.Unauthenticated;
      notifyListeners();
      return false;
    }
    try {
      Dio.Response response = await http().get('/user',
          options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
      this._user = User.fromJson(response.data);
      this._token = token;
      this._status = AuthStatus.Authenticated;
      await storeToken(token: token);
      notifyListeners();
      print(_user!.idPatient);
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
      String? tokenFirebase = await storage.read(key: 'token_firebase');
      Map data = {'token_firebase': tokenFirebase};
      Dio.Response response = await http().delete('/logout',
          options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}),
          data: data);
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
