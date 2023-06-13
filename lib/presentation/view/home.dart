import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_mind_app/presentation/view/widgets/home/media_card.dart';
import 'package:memory_mind_app/presentation/viewmodel/cubit/home_cubit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).getUserMedia();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
