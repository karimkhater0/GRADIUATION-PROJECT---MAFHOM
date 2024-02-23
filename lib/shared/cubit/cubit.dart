import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafhom/modules/account/account_screen.dart';
import 'package:mafhom/modules/login/login_screen.dart';
import 'package:mafhom/modules/register/register_screen.dart';
import 'package:mafhom/modules/saved/saved_screen.dart';
import 'package:mafhom/modules/text_to_sign/text_to_sign_screen.dart';
import 'package:mafhom/shared/cubit/states.dart';
import 'package:mafhom/shared/dio_helper.dart';
import 'package:mafhom/shared/end_points.dart';

import '../../modules/sign_to_text/sign_to_text_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  bool isLast = false;
  bool isPassword = false;
  bool isPasswordHidden = true;
  int currentIndex = 0;
  List<Widget> screens = [
    const TTSScreen(),
    const STTScreen(),
    const SavedScreen(),
    const AccountScreen(),
    LoginScreen(),
    RegisterScreen(),
  ];

  void changeOnBoardingPage(int index) {
    if (index == 2) {
      isLast = true;
      emit(AppChangeOnBoardingState());
    } else {
      isLast = false;
      emit(AppChangeOnBoardingState());
    }
  }

  void changeBottomNavBar(index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  IconData suffix = Icons.visibility_outlined;
  void changePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;

    suffix = isPasswordHidden
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(ShopChangePasswordVisibilityState());
  }

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(ShopLoginLoadingState());
    DioHelper.postData(
      url: LOGIN,
      data: {
        "email": email,
        "password": password,
      },
    ).then((value) {
      print(value.data);
      emit(ShopLoginSuccessState());
    }).catchError((error) {
      emit(ShopLoginErrorState(error.toString()));
    });
  }

  void userRegister({
    required String username,
    required String email,
    required String password,
  }) {
    emit(ShopRegisterInitialState());
    DioHelper.postData(
      url: REGISTER,
      data: {
        "username": username,
        "email": email,
        "password": password,
        "passwordConfirm": password,
        "fullName": "mommo yasser"
      },
    ).then((value) {
      print(value.data);
      emit(ShopRegisterSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopRegisterErrorState(error.toString()));
    });
  }
}
