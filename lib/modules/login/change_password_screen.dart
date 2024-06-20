import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafhom/shared/components.dart';
import 'package:mafhom/shared/constants.dart';
import 'package:mafhom/shared/cubit/cubit.dart';
import 'package:mafhom/shared/cubit/states.dart';
import 'package:mafhom/shared/sharedpreferences.dart';

class ChangePwScreen extends StatelessWidget {
  ChangePwScreen({super.key});
  final formKeyChange = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  final tokenController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, state) {
        if (state is ChangePwSuccessState) {
          if (state.loginModel?.message == "Successful Login") {
            SharedPreferencesHelper.saveData(
                key: "loginToken", value: state.loginModel?.token);
            SharedPreferencesHelper.saveData(
                key: "profilePicture", value: state.loginModel?.data?.photo);
            SharedPreferencesHelper.saveData(
                key: "userName", value: state.loginModel?.data?.fullName);
            SharedPreferencesHelper.saveData(
                key: "email", value: state.loginModel?.data?.email);

          }
        }
      },
      builder: (BuildContext context, state)
        {
          var cubit = AppCubit.get(context);
          return Scaffold(

            body: Container(
              height: screenHeight(context),
              decoration: backgroundDecoration,
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 16.0),
                    child: Column(
                      children: [
                        
                        ///APP BAR
                        CustomAppBar(),
                        
                        Form(
                          key: formKeyChange,
                          child: Column(
                            children: [
                              SizedBox(height: 40),
                              Text(
                                "Please enter your information",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: primaryColor,
                                ),
                              ),


                              SizedBox(height: 14),
                              ///CODE INPUT
                              formField(
                                controller: tokenController,
                                textType: TextInputType.visiblePassword,
                                labelText: 'Code',
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter The Code.';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: 30),
                              ///PASSWORD INPUT
                              formField(
                                context: context,
                                controller: newPasswordController,
                                textType: TextInputType.visiblePassword,
                                labelText: 'Password',
                                isPassword: true,
                                isPasswordHidden: cubit.isPasswordHidden,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter the New Password';
                                  }
                                  return null;
                                },
                              ),


                              SizedBox(height: 30),
                              ///CONFIRM PASSWORD INPUT
                              formField(
                                context: context,
                                controller: passwordConfirmationController,
                                textType: TextInputType.visiblePassword,
                                labelText: 'Password Confirm',
                                isPassword: true,
                                isPasswordHidden: cubit.isPasswordHidden,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter Confirm Password';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(height: 30),
                              ///CONFIRM BUTTON
                              defaultButton(
                                  backGround: primaryColor,
                                  text: 'Confirm',
                                  onPressed: () {
                                    if (formKeyChange.currentState!.validate()) {
                                      if(passwordConfirmationController.text == newPasswordController.text)
                                      {
                                        cubit.userResetPassword(
                                            code: tokenController.text,
                                            password: newPasswordController.text,
                                            context: context,
                                        );

                                      }
                                    }
                                  },
                                  width: 200,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}


String? validateFun(value) {
  if (value.isEmpty) {
    return 'Required';
  }
  return null;
}


class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          iconSize: 40,
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
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
    );
  }
}

