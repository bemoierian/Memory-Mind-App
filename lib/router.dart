import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_mind_app/data/repository/home_repository.dart';
import 'package:memory_mind_app/data/web_services/auth_webservices.dart';
import 'package:memory_mind_app/data/web_services/home_webservices.dart';
import 'package:memory_mind_app/presentation/view/home.dart';
import 'package:memory_mind_app/presentation/view/signin.dart';
import 'package:memory_mind_app/presentation/view/signup.dart';
import 'package:memory_mind_app/presentation/view/verify_email.dart';
import 'package:memory_mind_app/presentation/viewmodel/auth/auth_cubit.dart';
import 'package:memory_mind_app/presentation/viewmodel/home/home_cubit.dart';
import 'package:memory_mind_app/presentation/viewmodel/image_picker/image_picker_cubit.dart';
import 'package:memory_mind_app/presentation/viewmodel/remind_me/remind_me_cubit.dart';

import 'constants/strings.dart';
import 'data/repository/auth_repository.dart';

class AppRouter {
  late HomeWebServices homeWebServices;
  late HomeRepository homeRepository;
  late HomeCubit homeCubit;
  late ImagePickerCubit imagePickerCubit;
  late RemindMeCubit remindMeCubit;

  late AuthWebServices authWebServices;
  late AuthRepository authRepository;
  late AuthCubit authCubit;
  AppRouter() {
    homeWebServices = HomeWebServices();
    homeRepository = HomeRepository(homeWebServices);
    homeCubit = HomeCubit(homeRepository);
    imagePickerCubit = ImagePickerCubit();
    remindMeCubit = RemindMeCubit();

    authWebServices = AuthWebServices();
    authRepository = AuthRepository(authWebServices);
    authCubit = AuthCubit(authRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePageRoute:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: homeCubit,
              ),
              BlocProvider.value(
                value: authCubit,
              ),
              BlocProvider.value(
                value: imagePickerCubit,
              ),
              BlocProvider.value(
                value: remindMeCubit,
              ),
            ],
            child: const MyHomePage(title: 'Memory Mind'),
          ),
        );
      case signUpPageRoute:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: authCubit,
              ),
            ],
            child: SignUp(),
          ),
        );
      case signInPageRoute:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: authCubit,
              ),
            ],
            child: SignIn(),
          ),
        );
      case verifyEmailPageRoute:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: authCubit,
              ),
            ],
            child: VerifyEmail(),
          ),
        );
      default:
        return null;
    }
  }
}
