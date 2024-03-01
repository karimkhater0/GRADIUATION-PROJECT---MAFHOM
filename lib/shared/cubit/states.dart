abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeOnBoardingState extends AppStates {}

class AppChangeBottomNavBarState extends AppStates {}

class ChangePasswordVisibilityState extends AppStates {}

class LoginInitialState extends AppStates {}

class LoginSuccessState extends AppStates {}

class LoginLoadingState extends AppStates {}

class RegisterInitialState extends AppStates {}

class RegisterSuccessState extends AppStates {}

class RegisterLoadingState extends AppStates {}

class ForgetPwInitialState extends AppStates {}

class ForgetPwSuccessState extends AppStates {}

class ForgetPwLoadingState extends AppStates {}

class ChangePwInitialState extends AppStates {}

class ChangePwSuccessState extends AppStates {}

class ChangePwLoadingState extends AppStates {}

class LoginErrorState extends AppStates {
  final String error;
  LoginErrorState(this.error);
}

class RegisterErrorState extends AppStates {
  final String error;
  RegisterErrorState(this.error);
}

class ForgetPwErrorState extends AppStates {
  final String error;
  ForgetPwErrorState(this.error);
}

class ChangePwErrorState extends AppStates {
  final String error;
  ChangePwErrorState(this.error);
}

class AppChangeListeningState extends AppStates {}

class AppChangeTextState extends AppStates {}
