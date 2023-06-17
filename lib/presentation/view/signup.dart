import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_mind_app/constants/strings.dart';
import 'package:memory_mind_app/data/models/signup_req_model.dart';
import 'package:memory_mind_app/presentation/view/widgets/appbar/appbar.dart';
import 'package:memory_mind_app/presentation/viewmodel/auth/auth_cubit.dart';

class SignUp extends StatelessWidget {
  final TextEditingController nameInput = TextEditingController();
  final TextEditingController emailInput = TextEditingController();
  final TextEditingController pwInput = TextEditingController();
  SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: MemoryMindAppBar(
          title: appTitle,
          isSignedIn: false,
          pageNumber: 2,
        ),
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSignUpSuccessful) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("${state.message}, Log in to continue"),
              ),
            );
            Navigator.of(context).pushReplacementNamed(signInPageRoute);
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
                      hintText: "Enter your name",
                      constraints: BoxConstraints(
                        maxHeight: 300,
                        maxWidth: 300,
                      )),
                  controller: nameInput,
                ),
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
                    BlocProvider.of<AuthCubit>(context).signUp(SignUpReqModel(
                        name: nameInput.text,
                        email: emailInput.text,
                        password: pwInput.text));
                  },
                  child: const Text("Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
