import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_mind_app/presentation/view/widgets/appbar/appbar.dart';
import 'package:memory_mind_app/presentation/view/widgets/home/media_card.dart';
import 'package:memory_mind_app/presentation/viewmodel/auth/auth_cubit.dart';

import '../../constants/strings.dart';
import '../viewmodel/home/home_cubit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // BlocProvider.of<HomeCubit>(context).getUserMedia();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return MemoryMindAppBar(
                title: appTitle, isSignedIn: state is AuthSignInSuccessful);
          },
        ),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSignInSuccessful) {
            BlocProvider.of<HomeCubit>(context).getUserMedia(state.user.token!);
          } else if (state is AuthLoggedOut) {
            BlocProvider.of<HomeCubit>(context).resetUserMedia();
          }
        },
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoaded) {
              return GridView.count(
                crossAxisCount: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                shrinkWrap: true,
                children: [
                  ...state.media.media!.map((e) {
                    return MediaCard(
                      mediaURL: e.fileUrl!,
                      title: "",
                    );
                  }).toList()
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
