import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:memory_mind_app/data/models/signup_req_model.dart';
import 'package:memory_mind_app/data/models/verify_email_req_model.dart';
import 'package:memory_mind_app/data/repository/auth_repository.dart';
import 'package:memory_mind_app/utils/shared_prefs.dart';

import '../../../data/models/sign_in_req_model.dart';
import '../../../data/models/signin_res_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  String? userId;
  AuthCubit(this.authRepository) : super(AuthLoggedOut()) {
    signInFromSharedPrefs();
  }

  void signUp(SignUpReqModel signUpReqModel) {
    try {
      emit(AuthLoading());
      authRepository.signup(signUpReqModel).then((res) {
        if (res.userId != null) {
          userId = res.userId;
          emit(AuthVerifyEmail(userId: res.userId!, message: res.message!));
          // emit(AuthSignUpSuccessful(res.message ?? "Sign Up Successful"));
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
          userId = res.userId;
          if (res.isEmailVerified == false) {
            emit(AuthVerifyEmail(userId: res.userId!, message: res.message!));
          } else {
            saveUserToSharedPrefs(res.token!);
            emit(AuthSignInSuccessful(res));
          }
        } else {
          emit(AuthError(res.message ?? "Error In Sign In"));
        }
      });
    } catch (e) {
      emit(AuthError("Error In Sign In"));
    }
  }

  void verifyEmail(String codeInput) {
    try {
      VerifyEmailReqModel verifyEmailReqModel = VerifyEmailReqModel(
        signUpCode: codeInput,
        userId: userId,
      );
      emit(AuthLoading());
      authRepository.verifyEmail(verifyEmailReqModel).then((res) {
        if (res.userId != null) {
          if (res.isEmailVerified == false) {
            emit(AuthVerifyEmail(userId: res.userId!, message: res.message!));
          } else {
            saveUserToSharedPrefs(res.token!);
            emit(AuthSignInSuccessful(res));
          }
        } else {
          emit(AuthError(res.message ?? "Error in verifying email"));
        }
      });
    } catch (e) {
      emit(AuthError("Error in verifying email"));
    }
  }

  void resendVerificationEmail() {
    try {
      // emit(AuthLoading());
      authRepository.resendVerificationEmail(userId!).then((res) {
        if (res != 404) {
          emit(AuthVerifyEmail(
              userId: userId!, message: "Email sent successfully"));
        } else {
          emit(AuthError("Error in resending email"));
        }
      });
    } catch (e) {
      emit(AuthError("Error in resending email"));
    }
  }

  void logOut() {
    logOutFromSharedPrefs().then(
      (value) {
        userId = null;
        emit(AuthLoggedOut());
      },
    );
  }

  void signInFromSharedPrefs() {
    emit(AuthLoading());
    String user = SharedPrefsUtils.getString("user");
    if (user != '') {
      // final userModel = SignInResModel.fromJson(jsonDecode(user));
      authRepository.getUser(user).then((value) {
        userId = value.userId;
        emit(AuthSignInSuccessful(value));
      });
      // emit(AuthSignInSuccessful(userModel));
    } else {
      emit(AuthLoggedOut());
    }
    // emit(AuthSignInSuccessful(signInResModel));
  }

  void saveUserToSharedPrefs(String token) {
    SharedPrefsUtils.setString("user", token);
  }

  Future<void> logOutFromSharedPrefs() async {
    await SharedPrefsUtils.setString("user", "");
  }

  void updateProfilePicture(
      Uint8List fileAsBytes, String name, String mimeType, String token) {
    if (mimeType == "") {
      return;
    }
    if (state is AuthSignInSuccessful) {
      try {
        authRepository
            .updateProfilePicture(fileAsBytes, name, mimeType, token)
            .then((res) {
          if (res.message == "Profile picture updated.") {
            (state as AuthSignInSuccessful).user.profilePictureURL =
                res.profilePictureURL;
            emit(AuthSignInSuccessful((state as AuthSignInSuccessful).user));
          }
          // emit((state as HomeLoaded).copyWith(media));
          debugPrint("Media: ${res.profilePictureURL}");
        });
      } catch (e) {
        debugPrint("Error in home cubit:\n $e");
      }
    }
  }
}
