import 'package:flutter/material.dart';
import 'package:memory_mind_app/presentation/view/home.dart';

import 'constants/strings.dart';

class AppRouter {
  Router() {}
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePageRoute:
        return MaterialPageRoute(
            builder: (context) => const MyHomePage(title: 'Memory Mind'));
      default:
        return null;
    }
  }
}
