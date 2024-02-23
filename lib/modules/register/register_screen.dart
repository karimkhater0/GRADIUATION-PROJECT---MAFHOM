import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafhom/modules/login/login_screen.dart';
import 'package:mafhom/modules/text_to_sign/text_to_sign_screen.dart';
import 'package:mafhom/shared/components.dart';
import 'package:mafhom/shared/constants.dart';
import 'package:mafhom/shared/cubit/cubit.dart';
import 'package:mafhom/shared/cubit/states.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var registerUsernameController = TextEditingController();
    var registerEmailController = TextEditingController();
    var registeredPasswordController = TextEditingController();
    return BlocProvider(
      create: (context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, state) => Scaffold(
          body: SafeArea(
            child: Container(
              decoration: backgroundDecoration,
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/images/login/register.png'),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        formField(
                          controller: registerUsernameController,
                          textType: TextInputType.emailAddress,
                          labelText: 'User Name',
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a valid Username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        formField(
                          controller: registerEmailController,
                          textType: TextInputType.emailAddress,
                          labelText: 'Email',
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a valid Email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        formField(
                          context: context,
                          controller: registeredPasswordController,
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
                        (state is! ShopRegisterLoadingState)
                            ? defaultButton(
                                backGround: primaryColor,
                                text: 'Register',
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    AppCubit.get(context).userRegister(
                                      username: registerUsernameController.text,
                                      email: registerEmailController.text,
                                      password:
                                          registeredPasswordController.text,
                                    );
                                    navigateAndFinish(context, TTSScreen());
                                  }
                                },
                                width: screenWidth(context) * 0.6)
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "do You have already an account?",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: primaryColor),
                        ),
                        TextButton(
                          onPressed: () {
                            navigateAndFinish(context, LoginScreen());
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 19,
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
