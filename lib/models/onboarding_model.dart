import 'package:flutter/cupertino.dart';

class BoardingModel
{
  final String image;
  final String title;
  final String body;
  final CustomPainter customPainter;
  final double value;


  BoardingModel(
      {
        required this.image,
        required this.title,
        required this.body,
        required this.customPainter,
        required this.value,
      });


}