import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_mind_app/presentation/view/widgets/appbar/appbar.dart';
import 'package:memory_mind_app/presentation/viewmodel/auth/auth_cubit.dart';

import '../../constants/strings.dart';
import '../../data/models/sign_in_req_model.dart';

class SignIn extends StatelessWidget {
  final TextEditingController emailInput = TextEditingController();
  final TextEditingController pwInput = TextEditingController();
  SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: MemoryMindAppBar(
          title: appTitle,
          isSignedIn: false,
          pageNumber: 1,
        ),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSignInSuccessful) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Sign In Successful"),
              ),
            );
            Navigator.of(context).pushReplacementNamed(homePageRoute);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  decoration: const InputDecoration(
                      hintText: "Enter your email",
                      constraints: BoxConstraints(
                        maxHeight: 300,
                        maxWidth: 300,
                      )),
                  controller: emailInput,
                ),
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: "Enter your password",
                      constraints: BoxConstraints(
                        maxHeight: 300,
                        maxWidth: 300,
                      )),
                  controller: pwInput,
                ),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AuthCubit>(context).signIn(SignInReqModel(
                        email: emailInput.text, password: pwInput.text));
                  },
                  child: const Text("Sign In"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}