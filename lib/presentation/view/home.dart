import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_mind_app/data/models/media_model.dart';
import 'package:memory_mind_app/presentation/view/widgets/appbar/appbar.dart';
import 'package:memory_mind_app/presentation/view/widgets/home/left_sidebar.dart';
import 'package:memory_mind_app/presentation/view/widgets/home/media_card.dart';
import 'package:memory_mind_app/presentation/viewmodel/auth/auth_cubit.dart';
import 'package:memory_mind_app/presentation/viewmodel/image_picker/image_picker_cubit.dart';
import 'package:memory_mind_app/presentation/viewmodel/remind_me/remind_me_cubit.dart';
import 'package:video_player/video_player.dart';

import '../../constants/strings.dart';
import '../viewmodel/home/home_cubit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController contentInput = TextEditingController();
  DateTime currDate = DateTime.now();
  final scrollController = ScrollController();
  bool setupFirstTime = true;
  ImagePickerCubit profilePicturePickerCubit = ImagePickerCubit();

  void setupScrollController(context, String token) {
    debugPrint("Setting up scroll controller");
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          BlocProvider.of<HomeCubit>(context).getUserMedia(token: token);
        }
      }
    });
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
        builder: (context, authState) {
          // debugPrint("Auth authState changed");
          if (authState is AuthSignInSuccessful) {
            // debugPrint("Getting user media");
            BlocProvider.of<HomeCubit>(context)
                .getUserMedia(token: authState.user.token!);
            if (setupFirstTime) {
              setupScrollController(context, authState.user.token!);

              setupFirstTime = false;
            }
          } else if (authState is AuthLoggedOut) {
            // debugPrint("Reseting user media");
            BlocProvider.of<HomeCubit>(context).resetUserMedia();
          }
          return BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (authState is AuthSignInSuccessful) {
                List<Media> media = [];
                if (state is HomeLoading && state.firstTime) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is HomeLoading) {
                  media = state.oldMedia.media!;
                }
                if (state is HomeLoaded) {
                  media = state.media.media!;
                  if (state.media.usedStorage != null) {
                    // update used storage in authState
                    authState.user.usedStorage = state.media.usedStorage;
                  }
                }
                return Row(
                  children: [
                    BlocListener<ImagePickerCubit, ImagePickerState>(
                      bloc: profilePicturePickerCubit,
                      listener: (context, state) {
                        if (state is ImageSelected) {
                          BlocProvider.of<AuthCubit>(context)
                              .updateProfilePicture(
                                  state.bytes,
                                  state.selectedImageName,
                                  state.selectedImageMimeType,
                                  authState.user.token!);
                        }
                      },
                      child: LeftSideBar(
                        userName: authState.user.name!,
                        planName: "Free",
                        storageUsed: authState.user.usedStorage!,
                        storageLimit: authState.user.storageLimit!,
                        profilePictureURL: authState.user.profilePictureURL,
                        onProfilePictureTap: () {
                          profilePicturePickerCubit.pickImage();
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 300,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            GridView.builder(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 20, 20, 20),
                              // controller: scrollController,
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 300,
                                      // childAspectRatio: 3 / 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20),
                              shrinkWrap: true,
                              itemCount: media.length,
                              itemBuilder: (context, index) {
                                bool isVideo =
                                    media[index].fileType!.contains("video");

                                return MediaCard(
                                  mediaURL: media[index].fileUrl!,
                                  title: media[index].title!,
                                  isVideo: isVideo,
                                  onTapFunc:
                                      (VideoPlayerController? videoController) {
                                    showMediaDialog(
                                      context,
                                      media[index],
                                      isVideo,
                                      videoController,
                                      (authState).user.token!,
                                    );
                                  },
                                );
                                // }
                              },
                            ),
                            if (state is HomeLoading && !state.firstTime)
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
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
                    // TextField(
                    //   decoration: const InputDecoration(
                    //       hintText: "Title",
                    //       constraints: BoxConstraints(
                    //         maxHeight: 300,
                    //         maxWidth: 300,
                    //       )),
                    //   controller: titleInput,
                    // ),
                    const SizedBox(height: 30),
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
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                          lastDate: DateTime(
                                              DateTime.now().year,
                                              DateTime.now().month,
                                              DateTime.now().day + 3),
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
                                contentInput.text,
                                BlocProvider.of<RemindMeCubit>(parentContext)
                                        .value
                                    ? DateTime(currDate.year, currDate.month,
                                            currDate.day, 12, 0, 0)
                                        .toIso8601String()
                                    : null,
                                token,
                              );
                              BlocProvider.of<ImagePickerCubit>(context)
                                  .deleteImage();
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

  void showMediaDialog(parentContext, Media media, bool isVideo,
      VideoPlayerController? controller, String token) {
    ChewieController? chewieController;
    VideoPlayerController? videoPlayerController;
    if (isVideo && controller != null) {
      videoPlayerController = controller;
      chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: false,
        looping: false,
      );
    }

    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 20,
                      child: !isVideo
                          ? AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Image.network(
                                media.fileUrl!,
                                fit: BoxFit.fitHeight,
                                // width:
                                //     MediaQuery.of(context).size.width * 0.8 - 100,
                              ),
                            )
                          : AspectRatio(
                              aspectRatio: controller!.value.aspectRatio,
                              child: Chewie(
                                controller: chewieController!,
                              ),
                            ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 7,
                      child: Column(
                        children: [
                          Container(
                            // height: double.infinity,
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Title",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(media.title!),
                                const SizedBox(height: 15),
                                const Text(
                                  "Content",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(media.content!),
                                const SizedBox(height: 15),
                                const Text(
                                  "Uploaded at",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(media.createdAt!),
                                const SizedBox(height: 15),
                                const Text(
                                  "Modified at",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(media.updatedAt!),
                                const SizedBox(height: 15),
                                const Text(
                                  "Email Reminder",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(media.reminderDate ?? "None"),
                                const SizedBox(height: 15),
                                const Text(
                                  "Type",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(media.fileType!),
                                const SizedBox(height: 15),
                                const Text(
                                  "Size",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    "${(media.fileSize!).toStringAsFixed(2)} MB"),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<HomeCubit>(parentContext)
                                  .deleteMedia(media.sId!, token);
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                            ),
                            child: const Text("Delete"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      if (chewieController != null) {
        debugPrint("Disposing chewie controller");
        chewieController.dispose();
      }
    });
  }
}
