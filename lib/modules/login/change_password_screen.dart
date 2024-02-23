import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafhom/layout/home_layout.dart';
import 'package:mafhom/modules/login/forget_password_screen.dart';
import 'package:mafhom/modules/login/login_screen.dart';
import 'package:mafhom/modules/text_to_sign/text_to_sign_screen.dart';
import 'package:mafhom/shared/components.dart';
import 'package:mafhom/shared/constants.dart';
import 'package:mafhom/shared/cubit/cubit.dart';
import 'package:mafhom/shared/cubit/states.dart';

class ChangePwScreen extends StatelessWidget {
  ChangePwScreen({super.key});
  var formKeyChange = GlobalKey<FormState>();
  var newPasswordController = TextEditingController();
  var emailConfirmtionController = TextEditingController();
  var genCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, state) => Scaffold(
          body: Container(
            height: double.infinity,
            decoration: backgroundDecoration,
            child: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            iconSize: 40,
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: primaryColor,
                            ),
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) {
                              //     return ForgetPwScreen();
                              //   }),
                              // );
                              navigateAndFinish(context, ForgetPwScreen());
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Forgot Password",
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      Form(
                        key: formKeyChange,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 40,
                                ),
                                Text(
                                  "Please enter the your information",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: primaryColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 14,
                                ),
                                formField(
                                  controller: emailConfirmtionController,
                                  textType: TextInputType.emailAddress,
                                  labelText: 'Email',
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                formField(
                                  context: context,
                                  controller: newPasswordController,
                                  textType: TextInputType.visiblePassword,
                                  labelText: 'Password',
                                  isPassword: true,
                                  isPasswordHidden:
                                      AppCubit.get(context).isPasswordHidden,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter the New Password';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                formField(
                                  controller: genCodeController,
                                  textType: TextInputType.emailAddress,
                                  labelText: 'Code',
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                defaultButton(
                                    backGround: primaryColor,
                                    text: 'Confirm',
                                    onPressed: () {
                                      if (formKeyChange.currentState!
                                          .validate()) {
                                        //appcupit of the changing password
                                        navigateAndFinish(
                                            context, HomeLayout());
                                      }
                                    },
                                    width: screenWidth(context) * 0.6)
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
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
