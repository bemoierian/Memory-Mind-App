import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/strings.dart';
import '../../../viewmodel/auth/auth_cubit.dart';

class MemoryMindAppBar extends StatelessWidget {
  final String title;
  final bool isSignedIn;
  final int pageNumber;

  const MemoryMindAppBar(
      {required this.title,
      required this.isSignedIn,
      this.pageNumber = 0,
      super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: Row(
        children: [
          TextButton(
            onPressed: (() {
              if (pageNumber != 0) {
                Navigator.pushNamed(context, homePageRoute);
              }
            }),
            child: Text(title, style: Theme.of(context).textTheme.headline6),
          ),
          const SizedBox(
            width: 10,
          ),
          isSignedIn
              ? ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text("Upload"),
                )
              : const SizedBox(),
          const Spacer(),
          (isSignedIn)
              ? ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AuthCubit>(context).logOut();
                  },
                  child: const Text("Log Out"),
                )
              : Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, signUpPageRoute);
                      },
                      child: const Text("Sign Up"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, signInPageRoute);
                      },
                      child: const Text("Sign In"),
                    ),
                  ],
                ),
        ],
      ),
      centerTitle: true,
    );
  }
}
