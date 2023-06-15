import 'package:bloc/bloc.dart';
import 'package:memory_mind_app/data/models/signup_req_model.dart';
import 'package:memory_mind_app/data/repository/auth_repository.dart';

import '../../../data/models/sign_in_req_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;
  AuthCubit(this.authRepository) : super(AuthInitial());
  void signUp(SignUpReqModel signUpReqModel) {
    try {
      emit(AuthLoading());
      authRepository.signup(signUpReqModel).then((res) {
        if (res.userId != null) {
          emit(AuthSignUpSuccessful());
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
          emit(AuthSignUpSuccessful());
        } else {
          emit(AuthError(res.message ?? "Error In Sign In"));
        }
      });
    } catch (e) {
      emit(AuthError("Error In Sign In"));
    }
  }
}
