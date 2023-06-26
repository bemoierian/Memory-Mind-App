import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_mind_app/data/models/verify_email_req_model.dart';
import 'package:memory_mind_app/presentation/view/widgets/appbar/appbar.dart';
import 'package:memory_mind_app/presentation/viewmodel/auth/auth_cubit.dart';

import '../../constants/strings.dart';
import '../../data/models/sign_in_req_model.dart';

class VerifyEmail extends StatelessWidget {
  final TextEditingController codeInput = TextEditingController();
  VerifyEmail({super.key});

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
        child: SizedBox(
          width: double.infinity,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              Container(
                height: 300,
                width: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Verify Your Email!",
                      style: Theme.of(context).textTheme.headline3,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Enter your verification code",
                        constraints: BoxConstraints(
                          maxHeight: 300,
                          maxWidth: 300,
                        ),
                      ),
                      controller: codeInput,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<AuthCubit>(context)
                            .verifyEmail(codeInput.text);
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
                          return const Text("Verify");
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
