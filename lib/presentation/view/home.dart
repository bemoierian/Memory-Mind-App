import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_mind_app/presentation/view/widgets/appbar/appbar.dart';
import 'package:memory_mind_app/presentation/view/widgets/home/media_card.dart';
import 'package:memory_mind_app/presentation/viewmodel/auth/auth_cubit.dart';
import 'package:memory_mind_app/presentation/viewmodel/image_picker/image_picker_cubit.dart';
import 'package:memory_mind_app/presentation/viewmodel/remind_me/remind_me_cubit.dart';

import '../../constants/strings.dart';
import '../viewmodel/home/home_cubit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController titleInput = TextEditingController();
  final TextEditingController contentInput = TextEditingController();
  DateTime currDate = DateTime.now();
  @override
  void initState() {
    // BlocProvider.of<HomeCubit>(context).getUserMedia();
    // BlocProvider.of<AuthCubit>(context).signInFromSharedPrefs();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthSignInSuccessful) {
              return MemoryMindAppBar(
                title: appTitle,
                isSignedIn: true,
                pageNumber: 0,
                uploadOnClickFunction: () {
                  showUploadDialog(context, state.user.token!);
                },
              );
            }
            return const MemoryMindAppBar(
              title: appTitle,
              isSignedIn: false,
              pageNumber: 0,
            );
          },
        ),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          // debugPrint("Auth state changed");
          if (state is AuthSignInSuccessful) {
            // debugPrint("Getting user media");
            BlocProvider.of<HomeCubit>(context)
                .getUserMedia(token: state.user.token!);
          } else if (state is AuthLoggedOut) {
            // debugPrint("Reseting user media");
            BlocProvider.of<HomeCubit>(context).resetUserMedia();
          }
          return BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoaded) {
                return GridView.count(
                  padding: const EdgeInsets.all(20),
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
          );
        },
      ),
    );
  }

  void showUploadDialog(parentContext, String token) {
    showDialog(
        context: parentContext,
        builder: (BuildContext context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: BlocProvider.of<ImagePickerCubit>(parentContext),
              ),
              BlocProvider.value(
                value: BlocProvider.of<RemindMeCubit>(parentContext),
              ),
            ],
            child: AlertDialog(
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocBuilder<ImagePickerCubit, ImagePickerState>(
                          builder: (context, state) {
                            if (state is ImageLoading) {
                              return const CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey,
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is ImageSelected) {
                              return CircleAvatar(
                                radius: 60,
                                // child: CircularProgressIndicator(),
                                backgroundImage: MemoryImage(state.bytes),
                              );
                            }
                            return const CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey,
                            );
                          },
                        ),
                        const SizedBox(width: 30),
                        ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<ImagePickerCubit>(parentContext)
                                .pickImage();
                          },
                          child: const Text("Choose Image"),
                        ),
                      ],
                    ),
                    TextField(
                      decoration: const InputDecoration(
                          hintText: "Title",
                          constraints: BoxConstraints(
                            maxHeight: 300,
                            maxWidth: 300,
                          )),
                      controller: titleInput,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                          hintText: "Content",
                          constraints: BoxConstraints(
                            maxHeight: 300,
                            maxWidth: 300,
                          )),
                      controller: contentInput,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        BlocBuilder<RemindMeCubit, RemindMeState>(
                          builder: (context, state) {
                            return Switch(
                              value:
                                  BlocProvider.of<RemindMeCubit>(parentContext)
                                      .value,
                              onChanged: (value) {
                                BlocProvider.of<RemindMeCubit>(parentContext)
                                    .changeValue(value);
                              },
                            );
                          },
                        ),
                        const Text("Remind me"),
                      ],
                    ),
                    const SizedBox(height: 30),
                    BlocBuilder<RemindMeCubit, RemindMeState>(
                      builder: (context, state) {
                        return BlocProvider.of<RemindMeCubit>(parentContext)
                                .value
                            ? ElevatedButton(
                                onPressed: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime(
                                              DateTime.now().year,
                                              DateTime.now().month,
                                              DateTime.now().day + 1),
                                          firstDate: DateTime(
                                              DateTime.now().year,
                                              DateTime.now().month,
                                              DateTime.now().day + 1),
                                          lastDate:
                                              DateTime(DateTime.now().year + 5),
                                          currentDate: currDate)
                                      .then((value) {
                                    currDate = value!;
                                  });
                                },
                                child: const Text("Choose Date"),
                              )
                            : const SizedBox();
                      },
                    ),
                    const SizedBox(height: 30),
                    BlocBuilder<ImagePickerCubit, ImagePickerState>(
                      builder: (context, state) {
                        if (state is ImageSelected) {
                          return ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<HomeCubit>(parentContext)
                                  .uploadMedia(
                                state.bytes,
                                state.selectedImageName,
                                state.selectedImageMimeType,
                                titleInput.text,
                                contentInput.text,
                                token,
                              );
                              Navigator.pop(context);
                            },
                            child: const Text("Upload"),
                          );
                        }
                        return const ElevatedButton(
                          onPressed: null,
                          child: Text("Upload"),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
