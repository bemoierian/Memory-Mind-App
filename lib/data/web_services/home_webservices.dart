import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';

import '../../constants/strings.dart';

class HomeWebServices {
  late Dio dio;

  HomeWebServices() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      // connectTimeout: const Duration(seconds: 30),
      // receiveTimeout: const Duration(seconds: 30),
    );
    dio = Dio(options);
  }

  Future<dynamic> getUserMedia(
      {int? page, int? items, required String token}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) {
        queryParams["page"] = page;
      }
      if (items != null) {
        queryParams["items"] = items;
      }
      var res = await dio.get(
        'feed/user-media',
        queryParameters: queryParams,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      // print(res.data);
      return res.data;
    } catch (e) {
      debugPrint("Media $e");
      return {};
    }
  }

  Future<dynamic> uploadMedia(Uint8List fileAsBytes, String name,
      String mimeType, String title, String content, String token) async {
    final mediaType1 = mimeType.split('/')[0];
    final mediaType2 = mimeType.split('/')[1];
    try {
      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(fileAsBytes,
            filename: name, contentType: MediaType(mediaType1, mediaType2)),
        "title": title,
        "content": content,
      });
      Response response = await dio.post('feed/upload-media',
          data: formData,
          options: Options(
            headers: {"Authorization": "Bearer $token"},
          ));
      debugPrint(
          "update picture status code ${response.statusCode} new image link : " +
              response.data.toString());
      return response.data;
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }
}
