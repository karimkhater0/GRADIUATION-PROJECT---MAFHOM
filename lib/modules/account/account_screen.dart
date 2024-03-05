import 'package:flutter/material.dart';
import 'package:mafhom/modules/login/login_screen.dart';
import 'package:mafhom/shared/components.dart';
import 'package:mafhom/shared/constants.dart';
import 'package:mafhom/shared/sharedpreferences.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String imageUrl = sharedPreferencesHelper.getData(key: "profilePicture");
    String userName = sharedPreferencesHelper.getData(key: "userName");
    String email = sharedPreferencesHelper.getData(key: "email");

    return Scaffold(
      body: Container(
        decoration: backgroundDecoration,
        height: screenHeight(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
            ),
            Center(
              child: CircleAvatar(
                radius: 90,
                backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1484807352052-23338990c6c6?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: Text(
                userName,
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 34,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Email ",
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                email,
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Container(
                width: 200,
                height: 55,
                child: defaultButton(
                    backGround: primaryColor,
                    text: "Logout",
                    onPressed: () {
                      sharedPreferencesHelper.removeData(key: "loginToken");
                      navigateAndFinish(context, LoginScreen());
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
