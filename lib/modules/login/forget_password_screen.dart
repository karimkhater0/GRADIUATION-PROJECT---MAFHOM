import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafhom/modules/login/change_password_screen.dart';
import 'package:mafhom/modules/login/login_screen.dart';
import 'package:mafhom/shared/components.dart';
import 'package:mafhom/shared/constants.dart';
import 'package:mafhom/shared/cubit/cubit.dart';
import 'package:mafhom/shared/cubit/states.dart';

class ForgetPwScreen extends StatelessWidget {
  ForgetPwScreen({super.key});
  var formKeyForgot = GlobalKey<FormState>();
  var forgetEmailController = TextEditingController();
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return LoginScreen();
                                }),
                              );
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
                        key: formKeyForgot,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Image(
                                  image: AssetImage(
                                      'assets/images/login/forgot.png'),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Text(
                                  "Please enter your registered email",
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: primaryColor,
                                  ),
                                ),
                                Text(
                                  "address",
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: primaryColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Text(
                                  "we will send a code to your registered email",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: primaryColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 14,
                                ),
                                formField(
                                  controller: forgetEmailController,
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
                                defaultButton(
                                    backGround: primaryColor,
                                    text: 'Next',
                                    onPressed: () {
                                      if (formKeyForgot.currentState!
                                          .validate()) {
                                        // AppCubit.get(context).userForgetPw(
                                        //     email: forgetEmailController.text);
                                        navigateAndFinish(
                                            context, ChangePwScreen());
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
