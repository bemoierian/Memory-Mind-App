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
          } else if (state is AuthVerifyEmail) {
            Navigator.of(context).pushReplacementNamed(verifyEmailPageRoute);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        child: SizedBox(
          width: double.infinity,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              Container(
                  height: 400,
                  width: 500,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sign Up",
                        style: Theme.of(context).textTheme.headline3,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: "Enter your name",
                          constraints: BoxConstraints(
                            maxHeight: 300,
                            maxWidth: 300,
                          ),
                        ),
                        controller: nameInput,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: "Enter your email",
                          constraints: BoxConstraints(
                            maxHeight: 300,
                            maxWidth: 300,
                          ),
                        ),
                        controller: emailInput,
                      ),
                      const SizedBox(height: 20),
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
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<AuthCubit>(context).signUp(
                              SignUpReqModel(
                                  name: nameInput.text,
                                  email: emailInput.text,
                                  password: pwInput.text));
                        },
                        child: BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            if (state is AuthLoading) {
                              return const SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ));
                            }
                            return const Text("Sign Up");
                          },
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
