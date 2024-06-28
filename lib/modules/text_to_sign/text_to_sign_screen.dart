
import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:mafhom/shared/components.dart';
import 'package:mafhom/shared/sharedpreferences.dart';
import 'package:o3d/o3d.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;

import '../../shared/constants.dart';
import '../../shared/cubit/cubit.dart';

class TTSScreen extends StatefulWidget {
  TTSScreen({super.key});

  @override
  State<TTSScreen> createState() => _TTSScreenState();
}

class _TTSScreenState extends State<TTSScreen> {
  String? text;

  ///AVATAR
  final O3DController avatarController = O3DController();
  List<String> logs = [];
  List<String> animations = [];
  bool cameraControls = false;

  ///TEXT BOX WIDGET
  var textController = TextEditingController();
  bool isListening = false;
  double confidence = 1.0;
  SpeechToText speech = SpeechToText();
  static const String serverUrl = 'http://192.168.1.5:5000/process_text';  // Replace with your server's address


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



  void playAnimation(String arabicText) async {

    List<String> result = await processArabicText(arabicText);
    print(result);// This will print the list of tokens returned by your server
    for (int i = 0; i < result.length; i++) {
      avatarController.animationName = result[i];
      avatarController.play(repetitions: 1);
      await Future.delayed(const Duration(seconds: 3));
    }
  }

  Future<List<String>> processArabicText(String text) async {

    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'text': text,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return List<String>.from(data['result']);
      } else {
        throw Exception('Failed to process text: ${response.statusCode}');
      }
    } catch (e) {
      print('Error processing Arabic text: $e');
      return [];  // Return an empty list in case of error
    }
  }

  void initializeAvatar() {
    Future.delayed(const Duration(seconds: 5), () {
      avatarController.animationName = 'اهلا';
      avatarController.play(repetitions: 1);
    });
  }

  void returnedSavedSentence() {
    text = SharedPreferencesHelper.getData(key: 'savedSentence');
    print(text);
    SharedPreferencesHelper.removeData(key: 'savedSentence');
    if (text != null) {
      textController.text = text!;
    }
  }

  @override
  void initState() {
    super.initState();

    returnedSavedSentence();
    initializeAvatar();
  }

  @override
  Widget build(BuildContext context) {
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
                    width: double.infinity,
                    height: 350,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: O3D(

                      controller: avatarController,
                      src: 'assets/avatar/avatar.glb',
                      cameraControls: cameraControls,
                      cameraTarget: CameraTarget(0, 1, 0),
                      minFieldOfView: '10deg',
                      maxFieldOfView: '20deg',
                      disableTap: true,
                      disablePan: true,
                      disableZoom: true,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight(context) * .0875,
                  ),

                  ///TEXT BOX
                  Container(
                    height: screenHeight(context) * .15 < 120
                        ? 120
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
                              TextButton(
                                  onPressed: (){
                                    playAnimation(textController.text);
                                  },
                                  child: Text(
                                    'Translate',
                                    style: TextStyle(color: primaryColor),
                                  )),
                              Spacer(),
                              isListening
                                  ? AvatarGlow(
                                animate: true,
                                glowColor: primaryColor,
                                duration: const Duration(
                                    milliseconds: 2000),
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
                                    print(SharedPreferencesHelper.getData(
                                        key: 'sentences'));
                                    if (textController.text.length > 0) {
                                      cubit.createSavedSentence(
                                          textController.text);
                                    }
                                  },
                                  icon: Icon(Icons.bookmark_border)),
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



// class AvatarWidget extends StatefulWidget {
//   AvatarWidget({super.key});
//
//   @override
//   State<AvatarWidget> createState() => _AvatarWidgetState();
// }
//
// class _AvatarWidgetState extends State<AvatarWidget> {
//   final O3DController avatarController = O3DController();
//   List<String> logs = [];
//
//   List<String> animations = [];
//
//   bool cameraControls = false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     avatarController.logger = (data) {
//       logs.add(data.toString());
//     };
//
//     avatarController.animationName = 'اهلا';
//     avatarController.play(repetitions: 1);
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: screenHeight(context) * .5,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.blue.shade100.withOpacity(.3),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Expanded(
//           child: Card(
//             color: Colors.blue.shade100.withOpacity(.3),
//             elevation: 0,
//             child: AspectRatio(aspectRatio: 1, child:  O3D(
//               controller: avatarController,
//               src: 'assets/avatar1.glb',
//               cameraControls: cameraControls,
//               cameraTarget: CameraTarget(0, 1, 0),
//               minFieldOfView: '10deg',
//               maxFieldOfView: '20deg',
//               disableTap: true,
//               disablePan: true,
//               disableZoom: true,
//
//             )),
//           )),
//     );
//   }
// }
//
// class TextBoxWidget extends StatefulWidget {
//   TextBoxWidget({this.text,super.key});
//
//   String? text;
//
//   @override
//   State<TextBoxWidget> createState() => _TextBoxWidgetState();
// }
//
// class _TextBoxWidgetState extends State<TextBoxWidget> {
//   var textController = TextEditingController();
//   bool isListening = false;
//   double confidence = 1.0;
//   late SpeechToText speech;
//
//   final ArabicTextProcessor _processor = ArabicTextProcessor();
//   List<String> _result = [];
//
//   void listen() async {
//     var locales = await speech.locales();
//     var selectedLocale =
//     locales.firstWhere((locale) => locale.localeId.startsWith('ar'));
//     if (!isListening) {
//       bool available = await speech.initialize(
//         onStatus: (val) {
//           if (val == "done") {
//             setState(() {
//               isListening = false;
//             });
//           }
//           print("onStatus: $val");
//         },
//         onError: (val) {
//           print("onError: $val");
//           showToast(msg: 'Couldn\'t listen..', state: ToastStates.ERROR);
//         },
//       );
//       if (available) {
//         setState(() => isListening = true);
//         speech.listen(
//           onResult: (val) => setState(() {
//             textController.text = val.recognizedWords;
//             if (val.hasConfidenceRating && val.confidence > 0) {
//               confidence = val.confidence;
//             }
//           }),
//           localeId: selectedLocale.localeId,
//         );
//       }
//     } else {
//       setState(() {
//         isListening = false;
//         speech.stop();
//       });
//     }
//   }
//
//   void _processText() {
//     final text = textController.text;
//     final result = _processor.processArabicText(text);
//     setState(() {
//       _result = result;
//     });
//     print(_result);
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     speech = SpeechToText();
//     if(widget.text != null)
//       {
//         textController.text = widget.text!;
//       }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     AppCubit cubit = AppCubit.get(context);
//
//     return Container(
//       height:
//           screenHeight(context) * .15 < 120 ? 120 : screenHeight(context) * .15,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             ///ENTER TEXT
//             TextField(
//               controller: textController,
//               textDirection: TextDirection.rtl,
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 hintText: 'Write your text here',
//                 hintTextDirection: TextDirection.rtl,
//                 prefix: IconButton(
//                     onPressed: () {
//                       textController.text = '';
//                     },
//                     icon: Icon(
//                       Icons.close,
//                       color: Colors.black,
//                     )),
//               ),
//             ),
//
//             ///BUTTONS
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 TextButton(
//                     onPressed: _processText,
//                     child:
//                     Text('Translate',style: TextStyle(color: primaryColor),)),
//                 Spacer(),
//                 isListening
//                     ? AvatarGlow(
//                         animate: true,
//                         glowColor: primaryColor,
//                         duration: const Duration(milliseconds: 2000),
//                         repeat: true,
//                         child: IconButton(
//                           onPressed: listen,
//                           icon: Icon(Icons.mic),
//                         ),
//                       )
//                     : IconButton(
//                         onPressed: listen,
//                         icon: Icon(
//                           Icons.mic_none,
//                         ),
//                       ),
//                 IconButton(
//                     onPressed: () {
//                       print(SharedPreferencesHelper.getData(key: 'sentences'));
//                       if (textController.text.length > 0) {
//                         cubit.createSavedSentence(textController.text);
//                       }
//                     },
//                     icon: Icon(Icons.bookmark_border)),
//
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
// }
