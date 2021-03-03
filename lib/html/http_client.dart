import 'package:dio/dio.dart';
import 'package:robs_currency_calculator/utils/api_url.dart';


class HttpClient {
  Dio getDioInstance (){
    final Dio dio = Dio();
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = 20000;
    dio.options.receiveTimeout = 20000;
    return dio;
  }
}
