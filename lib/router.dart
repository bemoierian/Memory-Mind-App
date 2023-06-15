import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_mind_app/data/repository/home_repository.dart';
import 'package:memory_mind_app/data/web_services/home_webservices.dart';
import 'package:memory_mind_app/presentation/view/home.dart';
import 'package:memory_mind_app/presentation/viewmodel/home/home_cubit.dart';

import 'constants/strings.dart';

class AppRouter {
  late HomeWebServices homeWebServices;
  late HomeRepository homeRepository;
  late HomeCubit homeCubit;
  AppRouter() {
    homeWebServices = HomeWebServices();
    homeRepository = HomeRepository(homeWebServices);
    homeCubit = HomeCubit(homeRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePageRoute:
        return MaterialPageRoute(
            builder: (context) => BlocProvider.value(
                  value: homeCubit,
                  child: const MyHomePage(title: 'Memory Mind'),
                ));
      default:
        return null;
    }
  }
}
