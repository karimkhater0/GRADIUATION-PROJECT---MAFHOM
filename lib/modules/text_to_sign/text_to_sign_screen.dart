import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafhom/shared/components.dart';
import 'package:mafhom/shared/constants.dart';
import 'package:mafhom/shared/cubit/states.dart';

import '../../shared/cubit/cubit.dart';
import '../tts_camera/tts_camera_screen.dart';

class TTSScreen extends StatelessWidget {
  TTSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            body: SafeArea(
              child: Container(
                height: screenHeight(context),
                decoration: backgroundDecoration,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ///AVATAR
                        Container(
                          height: screenHeight(context) * .5,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight(context) * .0875,
                        ),

                        ///TEXT BOX
                        Container(
                          height: screenHeight(context) * .15 < 100
                              ? 100
                              : screenHeight(context) * .15,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ///ENTER TEXT
                                TextField(
                                  textDirection: TextDirection.rtl,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Write your text here...',
                                  ),
                                ),

                                ///BUTTONS
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    AvatarGlow(
                                      animate: false,
                                      glowColor: primaryColor,
                                      duration:
                                          const Duration(milliseconds: 2000),
                                      repeat: true,
                                      child: IconButton(
                                          onPressed: () {
                                            cubit.listen();
                                          },
                                          icon: Icon(Icons.mic)),
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.bookmark_border)),
                                    IconButton(
                                        onPressed: () {
                                          navigateTo(context,
                                              TextToSignCameraScreen());
                                        },
                                        icon: Icon(Icons.camera_alt)),
                                  ],
                                ),
                              ],
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
        },
      ),
    );
  }
}
