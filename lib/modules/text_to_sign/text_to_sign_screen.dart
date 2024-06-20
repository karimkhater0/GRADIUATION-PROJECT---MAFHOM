import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mafhom/shared/components.dart';
import 'package:mafhom/shared/cubit/states.dart';
import 'package:mafhom/shared/sharedpreferences.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../shared/constants.dart';
import '../../shared/cubit/cubit.dart';

class TTSScreen extends StatelessWidget {
  TTSScreen({super.key});
  String? text;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit,AppStates>(
      
      builder: (context,state){
          text = SharedPreferencesHelper.getData(key: 'savedSentence');
          print(text);
          SharedPreferencesHelper.removeData(key: 'savedSentence');

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
                      AvatarWidget(),
                      SizedBox(height: screenHeight(context) * .0875,),

                      ///TEXT BOX
                      TextBoxWidget(text:text,),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }

    );
  }
}

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight(context) * .5,
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}

class TextBoxWidget extends StatefulWidget {
  TextBoxWidget({this.text,super.key});

  String? text;

  @override
  State<TextBoxWidget> createState() => _TextBoxWidgetState();
}

class _TextBoxWidgetState extends State<TextBoxWidget> {
  var textController = TextEditingController();
  bool isListening = false;
  double confidence = 1.0;
  late SpeechToText speech;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    speech = SpeechToText();
    if(widget.text != null)
      {
        textController.text = widget.text!;
      }
  }

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);

    return Container(
      height:
          screenHeight(context) * .15 < 120 ? 120 : screenHeight(context) * .15,
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
            ///ENTER TEXT
            TextField(
              controller: textController,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Write your text here',
                hintTextDirection: TextDirection.rtl,
                prefix: IconButton(
                    onPressed: () {
                      textController.text = '';
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    )),
              ),
            ),

            ///BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                isListening
                    ? AvatarGlow(
                        animate: true,
                        glowColor: primaryColor,
                        duration: const Duration(milliseconds: 2000),
                        repeat: true,
                        child: IconButton(
                          onPressed: listen,
                          icon: Icon(Icons.mic),
                        ),
                      )
                    : IconButton(
                        onPressed: listen,
                        icon: Icon(
                          Icons.mic_none,
                        ),
                      ),
                IconButton(
                    onPressed: () {
                      print(SharedPreferencesHelper.getData(key: 'sentences'));
                      if (textController.text.length > 0) {
                        cubit.createSavedSentence(textController.text);
                      }
                    },
                    icon: Icon(Icons.bookmark_border)),

              ],
            ),
          ],
        ),
      ),
    );
  }

  void listen() async {
    var locales = await speech.locales();
    var selectedLocale =
        locales.firstWhere((locale) => locale.localeId.startsWith('ar'));
    if (!isListening) {
      bool available = await speech.initialize(
        onStatus: (val) {
          if (val == "done") {
            setState(() {
              isListening = false;
            });
          }
          print("onStatus: $val");
        },
        onError: (val) {
          print("onError: $val");
          showToast(msg: 'Couldn\'t listen..', state: ToastStates.ERROR);
        },
      );
      if (available) {
        setState(() => isListening = true);
        speech.listen(
          onResult: (val) => setState(() {
            textController.text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              confidence = val.confidence;
            }
          }),
          localeId: selectedLocale.localeId,
        );
      }
    } else {
      setState(() {
        isListening = false;
        speech.stop();
      });
    }
  }
}
