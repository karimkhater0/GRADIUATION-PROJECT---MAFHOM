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
import 'package:speech_to_text/speech_to_text.dart';

import '../../modules/sign_to_text/sign_to_text_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  bool isLast = false;
  bool isPassword = false;
  bool isPasswordHidden = true;
  int currentIndex = 0;
  List<Widget> screens = [
    TTSScreen(),
    STTScreen(),
    const SavedScreen(),
    const AccountScreen(),
    LoginScreen(),
    RegisterScreen(),
  ];
  bool isListening = false;
  SpeechToText? speech;
  String text ='Enter your text here';

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

  void listen() async {
    if (!isListening) {
      bool? available = await speech?.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available==true) {
        isListening = true;
        emit(AppChangeListeningState());
        speech?.listen(
          onResult: (val) {
            text = val.recognizedWords;
            emit(AppChangeTextState());

          }
        );
      }
    }
    else {
      isListening = false;
      emit(AppChangeListeningState());
      speech?.stop();
      print(text);
    }
  }
}
