abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeOnBoardingState extends AppStates {}

class AppChangeBottomNavBarState extends AppStates {}

class ShopChangePasswordVisibilityState extends AppStates {}

class ShopLoginInitialState extends AppStates {}

class ShopLoginSuccessState extends AppStates {}

class ShopLoginLoadingState extends AppStates {}

class ShopRegisterInitialState extends AppStates {}

class ShopRegisterSuccessState extends AppStates {}

class ShopRegisterLoadingState extends AppStates {}

class ShopForgetPwInitialState extends AppStates {}

class ShopForgetPwSuccessState extends AppStates {}

class ShopForgetPwLoadingState extends AppStates {}

class ShopChangePwInitialState extends AppStates {}

class ShopChangePwSuccessState extends AppStates {}

class ShopChangePwLoadingState extends AppStates {}

class ShopLoginErrorState extends AppStates {
  final String error;
  ShopLoginErrorState(this.error);
}

class ShopRegisterErrorState extends AppStates {
  final String error;
  ShopRegisterErrorState(this.error);
}

class ShopForgetPwErrorState extends AppStates {
  final String error;
  ShopForgetPwErrorState(this.error);
}

class ShopChangePwErrorState extends AppStates {
  final String error;
  ShopChangePwErrorState(this.error);
}

class AppChangeListeningState extends AppStates {}

class AppChangeTextState extends AppStates {}


