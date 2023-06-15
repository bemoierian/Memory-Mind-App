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
      return {};
    }
  }
}
