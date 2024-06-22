import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafhom/layout/home_layout.dart';
import 'package:mafhom/models/create_saved_sentence_model.dart';
import 'package:mafhom/models/delete_saved_sentence_model.dart';
import 'package:mafhom/models/saved_sentences_model.dart';
import 'package:mafhom/modules/account/account_screen.dart';
import 'package:mafhom/models/login_model.dart';

import 'package:mafhom/modules/saved/saved_screen.dart';
import 'package:mafhom/shared/components.dart';
import 'package:mafhom/shared/cubit/states.dart';
import 'package:mafhom/shared/dio_helper.dart';
import 'package:mafhom/shared/end_points.dart';
import 'package:mafhom/shared/sharedpreferences.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../modules/login/change_password_screen.dart';
import '../../modules/sign_to_text/sign_to_text_screen.dart';
import '../../modules/text_to_sign/text_to_sign_screen.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  List<dynamic> sentences = [];

  bool isLast = false;
  void changeOnBoardingPage(int index) {
    if (index == 2) {
      isLast = true;
      emit(AppChangeOnBoardingState());
    } else {
      isLast = false;
      emit(AppChangeOnBoardingState());
    }
  }

  void changeToHomeScreen(int index) {
    currentIndex = 0;
    emit(AppChangeBottomNavBarState(text: sentences[index]));
    print('Hola!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
  }

  int currentIndex = 0;
  List<Widget> screens = [
    TTSScreen(),
    STTScreen(),
    SavedScreen(),
    const AccountScreen(),
  ];
  void changeBottomNavBar(index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState(text: null));
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = false;
  bool isPasswordHidden = true;
  void changePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;

    suffix = isPasswordHidden
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(ChangePasswordVisibilityState());
  }

  LoginModel? loginModel;

  void userLogin({
    required String email,
    required String password,
    required context,
  }) {
    emit(LoginLoadingState());
    DioHelper.postData(
      url: LOGIN,
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) {
      // print('====================');
      // print(value.statusMessage);
      // print(value.statusCode);
      loginModel = LoginModel.fromJson(value.data);
      if (loginModel?.message == 'Successful Login') {
        emit(LoginSuccessState(loginModel));
        showToast(
            msg: loginModel!.message.toString(), state: ToastStates.SUCCESS);
        navigateAndFinish(context, HomeLayout());
      } else {
        showToast(
            msg: loginModel!.message.toString(), state: ToastStates.ERROR);
        emit(LoginErrorState());
      }
    }).catchError((error) {
      // print('______________________________');
      // print(error.toString());
      emit(LoginErrorState());
      showToast(
          msg: "Login failed, Check connection.", state: ToastStates.ERROR);
    });
  }

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
    required context,
  }) {
    emit(RegisterLoadingState());
    DioHelper.postData(
      url: REGISTER,
      data: {
        "userName": name,
        "email": email,
        "password": password,
        "passwordConfirm": password,
        "fullName": name,
      },
    ).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      if (loginModel?.message == 'Successful Login') {
        emit(RegisterSuccessState(loginModel));
        showToast(
            msg: loginModel!.message.toString(), state: ToastStates.SUCCESS);
        navigateAndFinish(context, HomeLayout());
      } else {
        emit(RegisterErrorState());
        showToast(
            msg: loginModel!.message.toString(), state: ToastStates.ERROR);
      }
      print(value.data);
    }).catchError((error) {
      showToast(
          msg: "Login failed, Check connection.", state: ToastStates.ERROR);
      print(error.message.toString());
      emit(RegisterErrorState());
    });
  }

  void userForgotPassword({required String email, required context}) {
    emit(ForgetPwLoadingState());

    DioHelper.postData(url: FORGOTPASSWORD, data: {
      "email": email,
    }).then((value) {
      if (value.data["status"] == "success") {
        emit(ForgetPwSuccessState());
        showToast(msg: value.data["message"], state: ToastStates.SUCCESS);
        navigateTo(context, ChangePwScreen());
      } else {
        emit(ForgetPwErrorState());
        showToast(msg: value.data["message"], state: ToastStates.SUCCESS);
      }
    }).catchError((error) {
      print(error.toString());
      emit(ForgetPwErrorState());
    });
  }

  void userResetPassword({
    required String code,
    required String password,
    required context,
  }) {
    emit(ChangePwLoadingState());

    DioHelper.patchData(url: RESETPASSWORD, data: {
      "token": code,
      "password": password,
      "passwordConfirm": password,
    }).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      if (loginModel?.message == 'Successful Login') {
        emit(ChangePwSuccessState(loginModel));
        showToast(
            msg: loginModel!.message.toString(), state: ToastStates.SUCCESS);
        navigateAndFinish(context, HomeLayout());
      } else {
        emit(ChangePwErrorState(loginModel!.message.toString()));
        showToast(
            msg: loginModel!.message.toString(), state: ToastStates.ERROR);
      }
      print(value.data);
    }).catchError((error) {
      print(error.toString());
      emit(ChangePwErrorState(error.toString()));
      showToast(msg: "Check connection.", state: ToastStates.ERROR);
    });
  }

  String? token = SharedPreferencesHelper.getData(key: 'loginToken');

  SavedSentencesModel? savedSentencesModel;
  void getSavedSentences() {
    if (sentences.isEmpty) {
      emit(AppGetSavedSentencesLoadingState());

      DioHelper.getData(
        url: GETSAVEDSENTENCES,
        token: token,
      ).then((value) {
        savedSentencesModel = SavedSentencesModel.fromJson(value?.data);
        sentences = savedSentencesModel!.data;
        print('=========================================');
        print(sentences);

        emit(AppGetSavedSentencesSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(AppGetSavedSentencesErrorState());
      });
    }
  }

  CreateSavedSentenceModel? createSavedSentenceModel;

  void createSavedSentence(String sentence) {
    emit(AppCreateSavedSentenceLoadingState());

    print(token);
    DioHelper.postData(url: CREATESAVEDSENTENCE, token: token, data: {
      "sentence": sentence,
    }).then((value) {
      createSavedSentenceModel = CreateSavedSentenceModel.fromJson(value.data);
      sentences = createSavedSentenceModel!.data;
      print(sentences);
      emit(AppCreateSavedSentenceSuccessState());
      showToast(msg: 'Sentence Saved Successfully', state: ToastStates.SUCCESS);
    }).catchError((error) {
      print(error.toString());
      emit(AppCreateSavedSentenceErrorState());
    });
  }

  DeleteSavedSentenceModel? deleteSavedSentenceModel;

  void deleteSavedSentence(int index) {
    emit(AppDeleteSavedSentenceLoadingState());

    sentences.removeAt(index);

    DioHelper.deleteData(
        url: DELETESAVEDSENTENCE,
        token: token,
        data: {"sentenceIndex": index}).then((value) {
      deleteSavedSentenceModel = DeleteSavedSentenceModel.fromJson(value.data);
      sentences = deleteSavedSentenceModel!.data;
      print(sentences);
      emit(AppDeleteSavedSentenceSuccessState());
      getSavedSentences();
    }).catchError((error) {
      print(error.toString());
      emit(AppDeleteSavedSentenceErrorState());
    });
  }

  bool isListening = false;
  SpeechToText speech = SpeechToText();
  String text = '';

  void initializeListening() {
    speech = SpeechToText();
    emit(AppInitialListeningState());
  }

  void listen() async {
    /// Arabic Text
    var locales = await speech.locales();
    var selectedLocale =
        locales.firstWhere((locale) => locale.localeId.startsWith('ar'));

    /// Listen
    if (!isListening) {
      bool? available = await speech.initialize(
        onStatus: (val) {
          print("onStatus: $val");
          if (val == "done") {
            isListening = false;
            emit(AppStopListeningState());
          }
        },
        onError: (val) => print("onError: $val"),
      );
      if (available == true) {
        isListening = true;
        emit(AppStartListeningState());

        speech.listen(
          onResult: (val) {
            text = val.recognizedWords;
          },
          localeId: selectedLocale.localeId,
        );
        emit(AppChangeTextState());
      }
    } else {
      isListening = false;
      speech.stop();
      emit(AppErrorListeningState());
    }

    print("============== $text");
  }

  void listen1(bool isListening) async {
    var locales = await speech.locales();
    var selectedLocale =
        locales.firstWhere((locale) => locale.localeId.startsWith('ar'));
    if (!isListening) {
      bool available = await speech.initialize(
        onStatus: (val) {
          if (val == "done") {
            emit(AppListeningState(false));
          }
          print("onStatus: $val");
        },
        onError: (val) => print("onError: $val"),
      );
      if (available) {
        emit(AppListeningState(true));
        speech.listen(
          onResult: (val) {
            text = val.recognizedWords;
          },
          localeId: selectedLocale.localeId,
        );
      }
    } else {
      emit(AppListeningState(false));
      speech.stop();
    }
  }
}
