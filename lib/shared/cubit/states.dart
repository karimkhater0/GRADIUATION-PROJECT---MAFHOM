import 'package:mafhom/models/login_model.dart';

abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeOnBoardingState extends AppStates {}

class AppChangeBottomNavBarState extends AppStates {
  String? text;
  AppChangeBottomNavBarState({this.text});
}

class ChangePasswordVisibilityState extends AppStates {}

///LOGIN STATES
class LoginInitialState extends AppStates {}

class LoginSuccessState extends AppStates {
  final LoginModel? loginModel;

  LoginSuccessState(this.loginModel);
}

class LoginLoadingState extends AppStates {}

class LoginErrorState extends AppStates {}


///REGISTER STATES
class RegisterSuccessState extends AppStates {
  final LoginModel? loginModel;

  RegisterSuccessState(this.loginModel,);
}

class RegisterLoadingState extends AppStates {}

class RegisterErrorState extends AppStates {}


///FORGET PASSWORD STATES

class ForgetPwSuccessState extends AppStates {}

class ForgetPwLoadingState extends AppStates {}

class ForgetPwErrorState extends AppStates {}


///CHANGE PASSWORD STATES
class ChangePwSuccessState extends AppStates {
  final LoginModel? loginModel;

  ChangePwSuccessState(this.loginModel,);
}

class ChangePwLoadingState extends AppStates {}

class ChangePwErrorState extends AppStates {
  final String error;
  ChangePwErrorState(this.error);
}

/// GET SAVED STATES
class AppGetSavedSentencesLoadingState extends AppStates{}

class AppGetSavedSentencesSuccessState extends AppStates{}

class AppGetSavedSentencesErrorState extends AppStates{}

/// CREATE SAVED STATES
class AppCreateSavedSentenceLoadingState extends AppStates{}

class AppCreateSavedSentenceSuccessState extends AppStates{}

class AppCreateSavedSentenceErrorState extends AppStates{}

/// DELETE SAVED STATES
class AppDeleteSavedSentenceLoadingState extends AppStates{}

class AppDeleteSavedSentenceSuccessState extends AppStates{}

class AppDeleteSavedSentenceErrorState extends AppStates{}


class AppInitialListeningState extends AppStates {}

class AppChangeListeningState extends AppStates {}

class AppStartListeningState extends AppStates {}
class AppStopListeningState extends AppStates {}
class AppListeningState extends AppStates {
  final bool isListening;
  AppListeningState(this.isListening);
}

class AppErrorListeningState extends AppStates {}

class AppChangeTextState extends AppStates {}
