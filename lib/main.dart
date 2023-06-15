import 'package:flutter/material.dart';
import 'package:memory_mind_app/router.dart';

import 'constants/strings.dart';

void main() {
  runApp(MyApp(router: AppRouter()));
}

class MyApp extends StatelessWidget {
  final AppRouter router;
  const MyApp({required this.router, super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Mind',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: router.generateRoute,
      initialRoute: homePageRoute,
    );
  }
}
