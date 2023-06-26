import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';

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
      return <String, dynamic>{};
    }
  }

  Future<dynamic> verifyEmail(Map<String, dynamic> verifyEmailReqModel) async {
    try {
      var res = await dio.post(
        'auth/verify-email',
        data: verifyEmailReqModel,
      );
      // print(res.data);
      return res.data;
    } catch (e) {
      debugPrint("Verify email Error in webservice\n $e");
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          return e.response?.data;
        }
      }
      return <String, dynamic>{};
    }
  }

  Future<dynamic> getUser(String token) async {
    try {
      var res = await dio.get(
        'user/get-user',
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

  Future<dynamic> updateProfilePicture(
      Uint8List fileAsBytes, String name, String mimeType, String token) async {
    try {
      final mediaType1 = mimeType.split('/')[0];
      final mediaType2 = mimeType.split('/')[1];
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(fileAsBytes,
            filename: name, contentType: MediaType(mediaType1, mediaType2)),
      });
      var res = await dio.post(
        'user/update-profile-picture',
        data: formData,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      // print(res.data);
      return res.data;
    } catch (e) {
      debugPrint("Profile picture Error in webservice\n $e");
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          return e.response?.data;
        }
      }
      return <String, dynamic>{};
    }
  }
}
