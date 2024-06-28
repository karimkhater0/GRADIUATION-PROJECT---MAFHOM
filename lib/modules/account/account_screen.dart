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
    String firstName =userName.split(' ')[0];

    return Scaffold(
      body: Container(
        decoration: backgroundDecoration,
        height: screenHeight(context),
        width: double.infinity,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    child: imageUrl.isNotEmpty
                        ? ClipOval(child: Image.network(imageUrl, fit: BoxFit.cover, width: 140, height: 140))
                        : Icon(Icons.account_circle, size: 140, color: primaryColor),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Hi $firstName.",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    email,
                    style: TextStyle(
                      color: primaryColor.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 30),
                  _buildInfoCard("Email", email),
                  SizedBox(height: 15),
                  _buildInfoCard("Username", userName),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      SharedPreferencesHelper.removeData(key: "loginToken");
                      navigateAndFinish(context, LoginScreen());
                    },
                    child: Text("Logout", style: TextStyle(fontSize: 18,color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: primaryColor.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                color: primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
