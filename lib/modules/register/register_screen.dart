import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafhom/modules/login/login_screen.dart';
import 'package:mafhom/shared/components.dart';
import 'package:mafhom/shared/constants.dart';
import 'package:mafhom/shared/cubit/cubit.dart';
import 'package:mafhom/shared/cubit/states.dart';
import 'package:mafhom/shared/sharedpreferences.dart';


class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var registerFullNameController = TextEditingController();
    var registerEmailController = TextEditingController();
    var registeredPasswordController = TextEditingController();
    var registeredPasswordConfirmController = TextEditingController();
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, state) {
        if (state is RegisterSuccessState) {
          if (state.loginModel?.message == "Successful Login") {
            SharedPreferencesHelper.saveData(
                key: "loginToken", value: state.loginModel?.token);
            SharedPreferencesHelper.saveData(
                key: "profilePicture", value: state.loginModel?.data?.photo);
            SharedPreferencesHelper.saveData(
                key: "userName", value: state.loginModel?.data?.fullName);
            SharedPreferencesHelper.saveData(
                key: "email", value: state.loginModel?.data?.email);
            SharedPreferencesHelper.saveData(
                key: 'savedSentences', value: state.loginModel?.data?.sentences);

          }
        }
      },
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
                      const SizedBox(height: 30,),

                      formField(
                        controller: registerFullNameController,
                        textType: TextInputType.name,
                        labelText: 'Name',
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Name.';
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
                            return 'Please enter your Email';
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
                      const SizedBox(height: 30,),

                      formField(
                        context: context,
                        controller: registeredPasswordConfirmController,
                        textType: TextInputType.visiblePassword,
                        labelText: 'Password Confirm',
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
                      const SizedBox(height: 30,),

                      (state is! RegisterLoadingState)
                          ? defaultButton(
                              backGround: primaryColor,
                              text: 'Register',
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  if(EmailValidator.validate(registerEmailController.text))
                                    {

                                      if(registeredPasswordController.text.length>=6)
                                      {
                                        AppCubit.get(context).userRegister(
                                          name: registerFullNameController.text,
                                          email: registerEmailController.text,
                                          password: registeredPasswordController.text,
                                          passwordConfirm : registeredPasswordConfirmController.text,
                                          context: context,
                                        );

                                      }
                                      else
                                      {
                                        showToast(
                                            msg: 'password must be more than 6 character',
                                            state: ToastStates.ERROR);
                                      }
                                    }
                                  else
                                  {
                                    showToast(
                                        msg: 'Please Enter a valid email',
                                        state: ToastStates.ERROR);
                                  }



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
    );
  }
}
