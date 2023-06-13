import 'package:flutter/material.dart';
import 'package:memory_mind_app/presentation/view/widgets/home/media_card.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: [
              const MediaCard(mediaURL: "", title: "title"),
            ],
          ),
        ],
      ),
    );
  }
}
