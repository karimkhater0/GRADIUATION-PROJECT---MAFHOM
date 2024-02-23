import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafhom/layout/home_layout.dart';
import 'package:mafhom/modules/login/forget_password_screen.dart';
import 'package:mafhom/modules/register/register_screen.dart';
import 'package:mafhom/modules/text_to_sign/text_to_sign_screen.dart';
import 'package:mafhom/shared/components.dart';
import 'package:mafhom/shared/constants.dart';

import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  var formKeyReg = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, state) => Scaffold(
          body: Container(
            decoration: backgroundDecoration,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKeyReg,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/images/login/login.png'),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        formField(
                          controller: emailController,
                          textType: TextInputType.emailAddress,
                          labelText: 'Email',
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        formField(
                          context: context,
                          controller: passwordController,
                          textType: TextInputType.visiblePassword,
                          labelText: 'Password',
                          isPassword: true,
                          isPasswordHidden:
                              AppCubit.get(context).isPasswordHidden,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        (state is! ShopLoginLoadingState)
                            ? defaultButton(
                                backGround: primaryColor,
                                text: 'Login',
                                onPressed: () {
                                  if (formKeyReg.currentState!.validate()) {
                                    AppCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                    navigateAndFinish(context, HomeLayout());
                                  }
                                },
                                width: screenWidth(context) * 0.6)
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return ForgetPwScreen();
                              }),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        Text(
                          "You don't have an account?",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: primaryColor),
                        ),
                        TextButton(
                          onPressed: () {
                            navigateAndFinish(context, RegisterScreen());
                          },
                          child: Text(
                            'Sign-Up',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
