import 'package:flutter/material.dart';

import '../../shared/constants.dart';

class STTScreen extends StatelessWidget {
  const STTScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: backgroundDecoration,
          height: screenHeight(context),
          child: Center(child: Text('STT Screen'))),
    );
  }
}