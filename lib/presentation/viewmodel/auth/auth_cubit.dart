import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:memory_mind_app/data/models/signup_req_model.dart';
import 'package:memory_mind_app/data/repository/auth_repository.dart';
import 'package:memory_mind_app/utils/shared_prefs.dart';

import '../../../data/models/sign_in_req_model.dart';
import '../../../data/models/signin_res_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  AuthCubit(this.authRepository) : super(AuthLoggedOut()) {
    signInFromSharedPrefs();
  }

  void signUp(SignUpReqModel signUpReqModel) {
    try {
      emit(AuthLoading());
      authRepository.signup(signUpReqModel).then((res) {
        if (res.userId != null) {
          emit(AuthSignUpSuccessful(res.message ?? "Sign Up Successful"));
        } else {
          emit(AuthError(res.message ?? "Error In Sign Up"));
        }
      });
    } catch (e) {
      emit(AuthError("Error In Sign Up"));
    }
  }

  void signIn(SignInReqModel signInReqModel) {
    try {
      emit(AuthLoading());
      authRepository.signIn(signInReqModel).then((res) {
        if (res.userId != null) {
          saveUserToSharedPrefs(res);
          emit(AuthSignInSuccessful(res));
        } else {
          emit(AuthError(res.message ?? "Error In Sign In"));
        }
      });
    } catch (e) {
      emit(AuthError("Error In Sign In"));
    }
  }

  void logOut() {
    logOutFromSharedPrefs().then(
      (value) {
        emit(AuthLoggedOut());
      },
    );
  }

  void signInFromSharedPrefs() {
    emit(AuthLoading());
    String user = SharedPrefsUtils.getString("user");
    if (user != '') {
      // debugPrint("Signed in from shared prefs");
      // debugPrint("user: $user");
      final userModel = SignInResModel.fromJson(jsonDecode(user));
      // debugPrint("usermodel: ${userModel.token}");
      emit(AuthSignInSuccessful(userModel));
    } else {
      emit(AuthLoggedOut());
    }
    // emit(AuthSignInSuccessful(signInResModel));
  }

  void saveUserToSharedPrefs(SignInResModel signInResModel) {
    SharedPrefsUtils.setString("user", jsonEncode(signInResModel.toJson()));
  }

  Future<void> logOutFromSharedPrefs() async {
    await SharedPrefsUtils.setString("user", "");
  }
}
