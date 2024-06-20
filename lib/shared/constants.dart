import 'package:flutter/material.dart';

Color primaryColor = Color(0xff4d689d);
double screenWidth(context) => MediaQuery.of(context).size.width;    // Gives the width
double screenHeight(context) => MediaQuery.of(context).size.height;

Decoration backgroundDecoration = const BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xfff5f5f5),
        Color(0xffbbcded),

        /// ADD HEX COLOR

      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    )
);






//Copy this CustomPainter code to the Bottom of the File
class VectorOnBoarding3 extends CustomPainter {
@override
void paint(Canvas canvas, Size size) {

Path path_0 = Path();
path_0.moveTo(size.width*0.4385304,size.height*0.001417008);
path_0.cubicTo(size.width*0.6020522,size.height*0.01632284,size.width*0.6666913,size.height*0.1796340,size.width*0.7694652,size.height*0.2876640);
path_0.cubicTo(size.width*0.8538957,size.height*0.3764124,size.width*0.9527609,size.height*0.4540400,size.width*0.9757000,size.height*0.5660600);
path_0.cubicTo(size.width*1.003565,size.height*0.7021360,size.width*1.032835,size.height*0.8714720,size.width*0.9072174,size.height*0.9603400);
path_0.cubicTo(size.width*0.7828348,size.height*1.048332,size.width*0.5994478,size.height*0.9652040,size.width*0.4385304,size.height*0.9460800);
path_0.cubicTo(size.width*0.3128417,size.height*0.9311440,size.width*0.1679043,size.height*0.9442200,size.width*0.08587000,size.height*0.8627320);
path_0.cubicTo(size.width*0.006609609,size.height*0.7840000,size.width*0.06535652,size.height*0.6689320,size.width*0.05595957,size.height*0.5660600);
path_0.cubicTo(size.width*0.04501087,size.height*0.4462040,size.width*-0.04360348,size.height*0.3244376,size.width*0.02715796,size.height*0.2199992);
path_0.cubicTo(size.width*0.1106478,size.height*0.09677400,size.width*0.2709070,size.height*-0.01386252,size.width*0.4385304,size.height*0.001417008);
path_0.close();

Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
paint_0_fill.color = Color(0xff4D689D).withOpacity(1.0);
canvas.drawPath(path_0,paint_0_fill);

}

@override
bool shouldRepaint(covariant CustomPainter oldDelegate) {
return true;
}
}

//Add this CustomPaint widget to the Widget Tree
// CustomPaint(
// size: Size(WIDTH, (WIDTH*1.0869565217391304).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
// painter: RPSCustomPainter(),
// )





//Copy this CustomPainter code to the Bottom of the File
class VectorOnBoarding2 extends CustomPainter {
@override
void paint(Canvas canvas, Size size) {

Path path_0 = Path();
path_0.moveTo(size.width*0.5692841,size.height*0.0006182847);
path_0.cubicTo(size.width*0.6964170,size.height*0.008847883,size.width*0.7932509,size.height*0.1079898,size.width*0.8754760,size.height*0.2063894);
path_0.cubicTo(size.width*0.9494096,size.height*0.2948599,size.width*0.9992325,size.height*0.4002044,size.width*0.9999889,size.height*0.5160328);
path_0.cubicTo(size.width*1.000756,size.height*0.6326606,size.width*0.9567196,size.height*0.7431131,size.width*0.8795646,size.height*0.8298066);
path_0.cubicTo(size.width*0.7977417,size.height*0.9217482,size.width*0.6915904,size.height*1.001245,size.width*0.5692841,size.height*0.9999854);
path_0.cubicTo(size.width*0.4478081,size.height*0.9987372,size.width*0.3582022,size.height*0.9025803,size.width*0.2652502,size.height*0.8234891);
path_0.cubicTo(size.width*0.1583609,size.height*0.7325365,size.width*0.009940369,size.height*0.6569781,size.width*0.0005272915,size.height*0.5160328);
path_0.cubicTo(size.width*-0.009096052,size.height*0.3719380,size.width*0.1148506,size.height*0.2604208,size.width*0.2212085,size.height*0.1640380);
path_0.cubicTo(size.width*0.3202432,size.height*0.07429161,size.width*0.4365756,size.height*-0.007972117,size.width*0.5692841,size.height*0.0006182847);
path_0.close();

Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
paint_0_fill.color = Color(0xffA7BEEA).withOpacity(1.0);
canvas.drawPath(path_0,paint_0_fill);

}

@override
bool shouldRepaint(covariant CustomPainter oldDelegate) {
return true;
}
}

//Add this CustomPaint widget to the Widget Tree
// CustomPaint(
// size: Size(WIDTH, (WIDTH*1.011070110701107).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
// painter: RPSCustomPainter(),
// )




//Copy this CustomPainter code to the Bottom of the File
class VectorOnBoarding1 extends CustomPainter {
@override
void paint(Canvas canvas, Size size) {

Path path_0 = Path();
path_0.moveTo(size.width*0.4857535,size.height*0.03389326);
path_0.cubicTo(size.width*0.6315903,size.height*0.03719318,size.width*0.7956979,size.height*-0.02629205,size.width*0.8990347,size.height*0.08429318);
path_0.cubicTo(size.width*1.010361,size.height*0.2034337,size.width*1.019059,size.height*0.3961553,size.width*0.9759479,size.height*0.5584848);
path_0.cubicTo(size.width*0.9355174,size.height*0.7107159,size.width*0.8167257,size.height*0.8118864,size.width*0.6862431,size.height*0.8854924);
path_0.cubicTo(size.width*0.5479410,size.height*0.9635114,size.width*0.3865035,size.height*1.046265,size.width*0.2476851,size.height*0.9693106);
path_0.cubicTo(size.width*0.1111486,size.height*0.8936174,size.width*0.1005736,size.height*0.7020189,size.width*0.06545590,size.height*0.5413485);
path_0.cubicTo(size.width*0.02989417,size.height*0.3786451,size.width*-0.05337083,size.height*0.1899470,size.width*0.05004792,size.height*0.06508258);
path_0.cubicTo(size.width*0.1518375,size.height*-0.05781477,size.width*0.3326476,size.height*0.03042879,size.width*0.4857535,size.height*0.03389326);
path_0.close();

Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
paint_0_fill.color = Color(0xff4D689D).withOpacity(1.0);
canvas.drawPath(path_0,paint_0_fill);

}

@override
bool shouldRepaint(covariant CustomPainter oldDelegate) {
return true;
}
}

//Add this CustomPaint widget to the Widget Tree
// CustomPaint(
// size: Size(WIDTH, (WIDTH*0.9166666666666666).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
// painter: RPSCustomPainter(),
// )