import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mafhom/layout/home_layout.dart';
import 'package:mafhom/shared/constants.dart';
import 'package:mafhom/shared/sharedpreferences.dart';

import 'cubit/cubit.dart';

Widget defaultButton({
  double width = double.infinity,
  required Color backGround,
  Color textColor = Colors.white,
  double radius = 15,
  required String text,
  required void Function()? onPressed,
}) =>
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backGround,
      ),
      width: width,
      child: RawMaterialButton(
        onPressed: onPressed,
        child: Text(text,
            style: TextStyle(
                color: textColor, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );

Widget formField({
  BuildContext? context,
  required TextEditingController controller,
  required TextInputType textType,
  required String labelText,
  required String? Function(String?)? validate,
  Function(String)? onSubmit,
  Function()? onTap,
  IconData? prefix = null,
  bool isPassword = false,
  bool isPasswordHidden = false,
  Color? backgroundColor = Colors.white,
}) =>
    Container(
      // height: 70,
      // decoration: BoxDecoration(
      //   color: backgroundColor,
      //   borderRadius: BorderRadius.circular(10),
      // ),
      child: TextFormField(
        controller: controller,
        keyboardType: textType,
        onTap: onTap,
        onFieldSubmitted: onSubmit,
        textAlign: TextAlign.center,
        validator: validate,
        obscureText: isPasswordHidden,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          hintText: labelText,
          hintStyle: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () {
                    AppCubit.get(context).changePasswordVisibility();
                  },
                  icon: Icon(
                    AppCubit.get(context).suffix,
                  ),
                )
              : const SizedBox(
                  width: 24,
                ),
        ),
      ),
    );

void showToast({
  required String msg,
  required ToastStates state,
}) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: changeToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

enum ToastStates { SUCCESS, ERROR, WARNING }

Color changeToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.black54;
      break;

    case ToastStates.ERROR:
      color = Color(0xffc75450);
      break;

    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );

navigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (context) => widget), (route) {
    return false;
  });
}

Widget myDivider() => Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20,
  ),
  child: Container(
    height: 1,
    width: double.infinity,
    color: Colors.grey,
  ),
);


Widget buildSavedItem(String sentence,int index, context) => Dismissible(
  key: Key(index.toString()),
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [

        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$sentence',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

            ],
          ),
        ),

        const SizedBox(width: 20,),

        ///go to home screen
        IconButton(
            color: Colors.black45,
            onPressed: () {
              print('---------------------------');
              print(sentence);
              SharedPreferencesHelper.saveData(key: 'savedSentence', value: sentence).then(
                      (value) => print('saved successfully'));
              navigateTo(context, HomeLayout());
            },
            icon: const Icon(Icons.arrow_forward_ios)),
      ],
    ),
  ),
  onDismissed: (direction) {
    AppCubit.get(context).deleteSavedSentence(index);
  },
);

