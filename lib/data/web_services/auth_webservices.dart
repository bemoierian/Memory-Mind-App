import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../constants/strings.dart';

class AuthWebServices {
  late Dio dio;

  AuthWebServices() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      // connectTimeout: const Duration(seconds: 30),
      // receiveTimeout: const Duration(seconds: 30),
    );
    dio = Dio(options);
  }

  Future<dynamic> signUp(Map<String, dynamic> signUpReqModel) async {
    try {
      var res = await dio.put(
        'auth/signup',
        data: signUpReqModel,
      );
      // print(res.data);
      return res.data;
    } catch (e) {
      debugPrint("Signup Error in webservice\n $e");
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          return e.response?.data;
        }
      }
      return {};
    }
  }

  Future<dynamic> signIn(Map<String, dynamic> signInReqModel) async {
    try {
      var res = await dio.post(
        'auth/login',
        data: signInReqModel,
      );
      // print(res.data);
      return res.data;
    } catch (e) {
      debugPrint("Signin Error in webservice\n $e");
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          return e.response?.data;
        }
      }
      return {};
    }
  }

  Future<dynamic> getUser(String token) async {
    try {
      var res = await dio.get(
        'auth/get-user',
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      // print(res.data);
      return res.data;
    } catch (e) {
      debugPrint("Get user Error in webservice\n $e");
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          return e.response?.data;
        }
      }
      return <String, dynamic>{};
    }
  }
}
