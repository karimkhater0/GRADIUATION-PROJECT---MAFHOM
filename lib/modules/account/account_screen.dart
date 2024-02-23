import 'package:flutter/material.dart';
import 'package:mafhom/shared/constants.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: backgroundDecoration,
          height: screenHeight(context),
          child: Center(child: Text('Account Screen'))),
    );
  }
}
