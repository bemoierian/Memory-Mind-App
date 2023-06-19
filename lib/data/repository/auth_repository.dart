import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:memory_mind_app/data/models/signup_req_model.dart';
import 'package:memory_mind_app/data/models/signup_res_model.dart';
import 'package:memory_mind_app/data/models/update_profile_picture_res_model.dart';

import '../models/sign_in_req_model.dart';
import '../models/signin_res_model.dart';
import '../web_services/auth_webservices.dart';

class AuthRepository {
  final AuthWebServices authWebServices;

  AuthRepository(this.authWebServices);

  Future<SignUpResModel> signup(SignUpReqModel signUpReqModel) async {
    try {
      final res = await authWebServices.signUp(signUpReqModel.toJson());
      final signUpResModel = SignUpResModel.fromJson(res);
      return signUpResModel;
    } catch (e) {
      debugPrint("Error in auth repository - Sign Up:\n $e");
      return SignUpResModel();
    }
  }

  Future<SignInResModel> signIn(SignInReqModel signInReqModel) async {
    try {
      final res = await authWebServices.signIn(signInReqModel.toJson());
      final signInResModel = SignInResModel.fromJson(res);
      return signInResModel;
    } catch (e) {
      debugPrint("Error in home repository Sign In:\n $e");
      return SignInResModel();
    }
  }

  Future<SignInResModel> getUser(String token) async {
    try {
      final res = await authWebServices.getUser(token);
      var signInResModel = SignInResModel.fromJson(res);
      signInResModel.token = token;
      return signInResModel;
    } catch (e) {
      debugPrint("Error in home repository get user:\n $e");
      return SignInResModel();
    }
  }

  Future<UpdateProfilePictureResModel> updateProfilePicture(
      Uint8List fileAsBytes, String name, String mimeType, String token) async {
    try {
      final media = await authWebServices.updateProfilePicture(
          fileAsBytes, name, mimeType, token);
      final mediaModel = UpdateProfilePictureResModel.fromJson(media);
      // print(mediaModel.media![0].fileUrl!);
      return mediaModel;
    } catch (e) {
      debugPrint("Error in auth repository - profile picture:\n $e");
      return UpdateProfilePictureResModel();
    }
  }
}
