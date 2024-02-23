import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafhom/shared/constants.dart';
import 'package:mafhom/shared/cubit/cubit.dart';
import 'package:mafhom/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (BuildContext context) =>AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (BuildContext context, AppStates state) {},
          builder: (BuildContext context, AppStates state) {
            AppCubit cubit =AppCubit.get(context);
            return Container(

              child: Scaffold(

                body: cubit.screens[cubit.currentIndex],
                bottomNavigationBar: CurvedNavigationBar(

                  buttonBackgroundColor: Colors.transparent,
                  backgroundColor: Color(0xffbbcded),
                  height: 50,
                  color: primaryColor,
                  animationDuration: const Duration(milliseconds: 200),
                  index: cubit.currentIndex,
                  onTap: (index) {
                    cubit.changeBottomNavBar(index);
                  },
                  items: const [
                    Icon(
                      Icons.text_fields,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.sign_language,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.bookmark,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
