import 'package:dio/dio.dart';
import 'package:robs_currency_calculator/html/http_client.dart';

abstract class IDataBaseRepository {
  Future<dynamic> get({String path});
}

class DataBaseRepository extends IDataBaseRepository {
  Dio dio = HttpClient().getDioInstance();

  @override
  Future<dynamic> get({String path}) async {
    try {
      final Response response = await dio.get(path);
      return response?.data;
    } catch (e) {
      rethrow;
    }
  }
}
