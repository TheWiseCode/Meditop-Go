import 'package:dio/dio.dart';

Dio dio(){
  Dio dio = new Dio();
  dio.options.baseUrl = "https://intense-crag-40595.herokuapp.com/api";
  dio.options.headers['Accept'] = 'Application/Json';
  return dio;
}