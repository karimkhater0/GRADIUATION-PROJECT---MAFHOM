import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafhom/shared/constants.dart';
import 'package:mafhom/shared/cubit/cubit.dart';
import 'package:mafhom/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {

  HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context) =>AppCubit(),
      child: BlocBuilder<AppCubit, AppStates>(

          builder: (BuildContext context, AppStates state) {
            AppCubit cubit =AppCubit.get(context);
            return Container(
              decoration: backgroundDecoration,


              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [

                    cubit.screens[cubit.currentIndex],

                    BottomNavBarWidget(),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class BottomNavBarWidget extends StatelessWidget {
  const BottomNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    AppCubit cubit =AppCubit.get(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, .2),
          borderRadius: BorderRadius.circular(40),
        ),

        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: cubit.currentIndex,
            onTap: (index){
              cubit.changeBottomNavBar(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.sign_language,
                ),
                label: 'TTS',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt),
                label: 'STT',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark),
                label: 'Saved',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ]),
      ),
    );
  }
}
