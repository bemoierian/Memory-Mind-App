import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:memory_mind_app/data/models/media_model.dart';
import 'package:memory_mind_app/data/web_services/home_webservices.dart';

class HomeRepository {
  final HomeWebServices homeWebServices;

  HomeRepository(this.homeWebServices);

  Future<MediaModel> getUserMedia(
      {required String token, int? page, int? items}) async {
    try {
      final media = await homeWebServices.getUserMedia(
          token: token, page: page, items: items);
      final mediaModel = MediaModel.fromJson(media);
      // print(mediaModel.media![0].fileUrl!);
      return mediaModel;
    } catch (e) {
      debugPrint("Error in home repository:\n $e");
      return MediaModel();
    }
  }

  Future<MediaModel> uploadMedia(
      Uint8List fileAsBytes,
      String name,
      String mimeType,
      String title,
      String content,
      String? remindeMeDate,
      String token) async {
    try {
      final media = await homeWebServices.uploadMedia(
          fileAsBytes, name, mimeType, title, content, remindeMeDate, token);
      final mediaModel = MediaModel.fromJson(media);
      // print(mediaModel.media![0].fileUrl!);
      return mediaModel;
    } catch (e) {
      debugPrint("Error in home repository:\n $e");
      return MediaModel();
    }
  }

  Future<int> deleteMedia(String mediaID, String token) async {
    try {
      final int statusCode = await homeWebServices.deleteMedia(mediaID, token);
      return statusCode;
    } catch (e) {
      debugPrint("Error in home repository, delete media:\n $e");
      return 404;
    }
  }
}
