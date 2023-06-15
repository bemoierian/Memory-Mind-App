import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_mind_app/presentation/viewmodel/auth/auth_cubit.dart';

import '../../data/models/sign_in_req_model.dart';

class SignIn extends StatelessWidget {
  final TextEditingController emailInput = TextEditingController();
  final TextEditingController pwInput = TextEditingController();
  SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
        centerTitle: true,
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSignInSuccessful) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Sign In Successful"),
              ),
            );
            Navigator.pop(context);
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
