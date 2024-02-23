import 'package:flutter/material.dart';
import 'package:mafhom/shared/constants.dart';

class TTSScreen extends StatelessWidget {
  const TTSScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Container(
                    height: screenHeight(context)*.5,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(15),

                    ),
                  ),

                  SizedBox(height: screenHeight(context)*.0875,),
                  Container(
                    height: screenHeight(context)*.15<100?100:screenHeight(context)*.15,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextField(
                            textDirection: TextDirection.rtl,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Write your text here...',


                            ),

                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              IconButton(onPressed: (){}, icon: Icon(Icons.bookmark_border)),
                              IconButton(onPressed: (){}, icon: Icon(Icons.mic)),
                              IconButton(onPressed: (){}, icon: Icon(Icons.camera_alt)),
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
  }
}