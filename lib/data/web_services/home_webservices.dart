import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class HomeWebServices {
  late Dio dio;

  HomeWebServices() {
    BaseOptions options = BaseOptions(
      baseUrl: "localhost:8080/",
      receiveDataWhenStatusError: true,
      // connectTimeout: 30 * 1000,
      // receiveTimeout: 30 * 1000,
    );
    dio = Dio(options);
  }

  Future<dynamic> getUserMedia(String token) async {
    try {
      var res = await dio.get('user-media',
          options: Options(
            headers: {"Authorization": "Bearer $token"},
          ));
      // print(res.data);
      return res.data;
    } on DioException catch (e) {
      debugPrint("Media $e");
      return {};
    }
  }
}
