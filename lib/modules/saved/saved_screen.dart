import 'package:flutter/material.dart';

import '../../shared/constants.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: backgroundDecoration,
          height: screenHeight(context),
          child: Center(child: Text('Saved Screen'))),
    );
  }
}