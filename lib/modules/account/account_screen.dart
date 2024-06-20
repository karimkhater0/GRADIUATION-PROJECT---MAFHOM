import 'package:flutter/material.dart';
import 'package:mafhom/modules/login/login_screen.dart';
import 'package:mafhom/shared/components.dart';
import 'package:mafhom/shared/constants.dart';
import 'package:mafhom/shared/sharedpreferences.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String imageUrl = SharedPreferencesHelper.getData(key: "profilePicture");
    String userName = SharedPreferencesHelper.getData(key: "userName");
    String email = SharedPreferencesHelper.getData(key: "email");

    return Scaffold(
      body: Container(
        decoration: backgroundDecoration,
        height: screenHeight(context),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: screenHeight(context) < 560
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 100,
                          child: Icon(
                            Icons.account_circle,
                            size: 200,
                            color: primaryColor,
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Text(
                          userName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 34,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "Email ",
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        email,
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
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
                                SharedPreferencesHelper.removeData(
                                    key: "loginToken");
                                navigateAndFinish(context, LoginScreen());
                              }),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 100,
                        child: Icon(
                          Icons.account_circle,
                          size: 200,
                          color: primaryColor,
                        ),
                        // child: imageUrl.isNotEmpty
                        //     ? Image.network(imageUrl)
                        //     :Icon(
                        //   Icons.account_circle,
                        //   size: 200,
                        //   color: primaryColor,
                        // ),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text(
                        userName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 34,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      "Email ",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      email,
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
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
                              SharedPreferencesHelper.removeData(
                                  key: "loginToken");
                              navigateAndFinish(context, LoginScreen());
                            }),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
