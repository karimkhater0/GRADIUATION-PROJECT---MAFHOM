import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafhom/modules/login/login_screen.dart';
import 'package:mafhom/shared/cubit/cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../models/onboarding_model.dart';
import '../../shared/components.dart';
import '../../shared/constants.dart';
import '../../shared/cubit/states.dart';

class OnBoardingScreen extends StatelessWidget {
  List<BoardingModel> boarding = [
    BoardingModel(
      image: 'assets/images/onboarding/1.png',
      title: 'Welcome to Mafhom!',
      body:
          '''Experience the power of communication without barriers. Easily translate gestures into text and vice versa. Start communicating inclusively today!''',
      customPainter: VectorOnBoarding1(),
      value: 0.9166666666666666,
    ),
    BoardingModel(
      image: 'assets/images/onboarding/2.png',
      title: 'Learn,Translate and Connect.',
      body:
          ''' With Mafhom, learn new signs, translate effortless, and connect with the the deaf and dumb around you.''',
      customPainter: VectorOnBoarding2(),
      value: 1.011070110701107,
    ),
    BoardingModel(
      image: 'assets/images/onboarding/3.png',
      title: 'Unlock the world of Egyptian Sign Language.',
      body:
          'Our app empowers you to bridge language gaps, Understand and be understood. Begin your journey to understanding Egyptian Sign Language with us.',
      customPainter: VectorOnBoarding3(),
      value: 1.0869565217391304,
    ),
  ];

  var boardController = PageController();

  @override
  Widget build(BuildContext context) {
    //var cubit = AppCubit.get(context);

    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) => Scaffold(

          body: SafeArea(
            child: Container(
              decoration: backgroundDecoration,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20,5,20,12),
                child: Column(

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: (){
                              navigateAndFinish(context, LoginScreen());
                            },
                            child: Text(
                              'SKIP',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            )),
                      ],
                    ),
                    Expanded(
                      child: PageView.builder(
                        physics: const BouncingScrollPhysics(),
                        controller: boardController,
                        onPageChanged: (int index) {
                          AppCubit.get(context).changeOnBoardingPage(index);
                        },
                        itemBuilder: (context, index) =>
                            buildBoardingItem(boarding[index], context),
                        itemCount: boarding.length,
                      ),
                    ),

                    ///BUTTONS
                    AppCubit.get(context).isLast
                        ? defaultButton(
                            text: 'Get Started',
                            backGround: primaryColor,
                            width: MediaQuery.of(context).size.width * .60,
                            onPressed: () {
                              navigateAndFinish(context, LoginScreen());
                            },
                          )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FloatingActionButton(
                              onPressed: () {
                                boardController.nextPage(
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.fastEaseInToSlowEaseOut,
                                );
                              },
                              backgroundColor: primaryColor,
                              shape: CircleBorder(),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///IMAGE, INDICATOR, TITLE
  Widget buildBoardingItem(BoardingModel model, context) {
    double vectorWidth =
        screenWidth(context) <= 500.0 ? screenWidth(context) - 100 : 400.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ///IMAGE, VECTOR
        Expanded(
          flex: 3,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(vectorWidth, vectorWidth * model.value),
                painter: model.customPainter,
              ),
              Image(
                image: AssetImage(model.image),
                height: vectorWidth * model.value,
                fit: BoxFit.fitHeight,
              ),
            ],
          ),
        ),

        ///INDICATOR
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SmoothPageIndicator(
                controller: boardController,
                effect: ExpandingDotsEffect(
                  dotColor: Colors.black,
                  activeDotColor: Colors.black,
                  dotHeight: 12,
                  expansionFactor: 3,
                  dotWidth: 15,
                  spacing: 26,
                ),
                count: 3,
              ),

              // FloatingActionButton(
              //   onPressed: () {
              //     if(isLast)
              //     {
              //
              //       submit();
              //     }
              //     else
              //     {
              //       boardController.nextPage(
              //         duration: const Duration(
              //           microseconds: 750,
              //         ),
              //         curve: Curves.fastLinearToSlowEaseIn,
              //       );
              //     }
              //
              //
              //   },
              //   child: const Icon(
              //       Icons.arrow_forward_ios
              //   ),
              // ),
            ],
          ),
        ),

        ///TITLE
        Expanded(
          flex: 1,
          child: Text(
            model.title,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                overflow: TextOverflow.ellipsis),
          ),
        ),

        ///BODY
        Expanded(
          flex: 2,
          child: Text(
            model.body,
            maxLines: 6,
            style: TextStyle(
              fontSize: 17,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
