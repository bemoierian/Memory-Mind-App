import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomeWebServices {
  late Dio dio;

  HomeWebServices() {
    BaseOptions options = BaseOptions(
      baseUrl: "http://localhost:8080/",
      receiveDataWhenStatusError: true,
      // connectTimeout: const Duration(seconds: 30),
      // receiveTimeout: const Duration(seconds: 30),
    );
    dio = Dio(options);
  }

  Future<dynamic> getUserMedia(String token) async {
    try {
      var res = await dio.get(
        'feed/user-media',
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      print(res.data);
      return res.data;
    } catch (e) {
      debugPrint("Media $e");
      return {};
    }
  }
}
