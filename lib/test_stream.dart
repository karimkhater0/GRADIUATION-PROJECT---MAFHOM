import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';

import '../../shared/constants.dart';

class STTScreen1 extends StatefulWidget {
  @override
  State<STTScreen1> createState() => _STTScreenState();
}

class _STTScreenState extends State<STTScreen1> {
  ///Camera
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  bool isCameraReady = false;
  int direction = 1;

  ///Model
  bool _isDetecting = false;
  String _detectedSentence = '';

  bool isRecording = false;
  List<String> _predictions = [''];
  static const String api = 'http://192.168.56.226:5000/predict_sequence';

  String arabicText = '';

  final translator = GoogleTranslator();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startCamera(direction);
  }

  Future<void> startCamera(int direction) async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras[direction],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        isCameraReady = true;
        //startDetection();
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> recordVideoAndDetect() async {
    if (isRecording) return;
    isRecording = true;
    arabicText = '';
    setState(() {});

    try {
      // Start video recording
      await cameraController.startVideoRecording();

      // Record for 3 seconds (30 frames at 10 fps)
      await Future.delayed(const Duration(seconds: 2));

      // Stop recording
      final XFile videoFile = await cameraController.stopVideoRecording();

      // Send video for detection
      await detectVideo(videoFile);
    } catch (e) {
      print('Error recording video: $e');
      _showErrorDialog('Failed to record video: $e');
    } finally {
      isRecording = false;
      setState(() {});
    }
  }

  Future<void> detectVideo(XFile videoFile) async {
    if (_isDetecting) return;
    _isDetecting = true;
    setState(() {});

    try {
      print('Preparing video for upload');
      final bytes = await videoFile.readAsBytes();
      final base64Video = base64Encode(bytes);

      final payload = jsonEncode({'video': base64Video});
      print('________Start Server request________');

      final response = await http
          .post(
            Uri.parse(api),
            headers: {'Content-Type': 'application/json'},
            body: payload,
          )
          .timeout(const Duration(
              seconds: 60)); // Increased timeout for video upload

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        _detectedSentence = result['predicted_sentence'];
        _predictions = List<String>.from(result['predictions']);
        translate(_predictions[0]);
        setState(() {});
        print('Predicted sentence: $_detectedSentence');
      } else {
        throw Exception(
            'Server error: ${response.statusCode}\n${response.body}');
      }
    } catch (e) {
      print('Error during detection: $e');
      _showErrorDialog('Failed to detect sign language: $e');
    } finally {
      _isDetecting = false;
      setState(() {});
    }
  }

  void translate(String text) async {
    var translatedText = await translator.translate(text, from: 'en', to: 'ar');
    print(translatedText);
    arabicText = translatedText.toString();
    setState(() {});
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isCameraReady
        ? Scaffold(
            body: Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: CameraPreview(cameraController)),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 8.0, right: 8.0),
                            child: Text(
                              "${_predictions[0]}",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    ///Switch Button
                    !isRecording
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SafeArea(
                              child: FloatingActionButton(
                                onPressed: recordVideoAndDetect,
                                child: Icon(
                                  isRecording ? Icons.stop : Icons.videocam,
                                  color: primaryColor,
                                ),
                                shape: CircleBorder(),
                                backgroundColor: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          )
                        : SizedBox(),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SafeArea(
                        child: FloatingActionButton(
                          onPressed: (){
                            direction == 1 ? direction = 0 : direction = 1;
                            startCamera(direction);
                          },
                          child: Icon(
                            Icons.cameraswitch,
                            color: primaryColor,
                          ),
                          shape: CircleBorder(),
                          backgroundColor: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : Container(
            decoration: backgroundDecoration,
            width: double.infinity,
            height: double.infinity,
          );
  }
}
