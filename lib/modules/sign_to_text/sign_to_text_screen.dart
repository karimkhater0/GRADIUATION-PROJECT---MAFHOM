import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../shared/constants.dart';

class STTScreen extends StatefulWidget {
  @override
  State<STTScreen> createState() => _STTScreenState();
}

class _STTScreenState extends State<STTScreen> {
  ///Camera
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  bool isCameraReady = false;
  int direction = 1;

  ///Model
  bool _isDetecting = false;
  bool _isCapturing = false;
  String _detectedSentence = '';

  bool isRecording = false;

  List<String> _predictions = [''];
  List<XFile> _frameBuffer = [];
  static const String api = 'http://192.168.1.6:5000/predict_sequence';

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
      ResolutionPreset.medium,
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

    // Future.delayed(const Duration(seconds: 1), () {
    //   setState(() {
    //
    //   });
    // });
  }



  Future<void> startDetection() async {
    _frameBuffer.clear();
    isRecording = true;
    setState(() {});

    for (int i = 0; i < 30; i++) {
      if (!isRecording) break;
      if (cameraController.value.isInitialized) {
        try {
          await captureFrame();
          print('_______TAKING FRAME: ${i}_______');
        } catch (e) {
          print('Failed to take frame ${i}: $e');
        }
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }

    isRecording = false;
    setState(() {});

    if (_frameBuffer.length == 30) {
      await detectSequence();
    } else {
      print('Failed to capture all 30 frames');
    }
  }

  Future<void> captureFrame() async {
    if (_isCapturing) return;
    _isCapturing = true;

    try {
      print('_______CAPTURING IMAGE_______');
      final XFile image = await cameraController.takePicture();
      print('Captured image: ${image.path}');
      addFrameToBuffer(image);
    } catch (e) {
      print('Error capturing frame: $e');
      rethrow;
    } finally {
      _isCapturing = false;
    }
  }

  void addFrameToBuffer(XFile image) {
    if (_frameBuffer.length < 30) {
      _frameBuffer.add(image);
    }
    // We don't need an else clause here as we're managing the sequence in startDetection
  }

  Future<void> detectSequence() async {
    if (_isDetecting) return;
    _isDetecting = true;
    setState(() {});

    try {
      print('Preprocessing sequence');
      List<String> base64Frames = await Future.wait(
          _frameBuffer.map((frame) async {
            final bytes = await frame.readAsBytes();
            return base64Encode(bytes);
          })
      );

      final payload = jsonEncode({'frames': base64Frames});
      print('________Start Server request________');

      final response = await http.post(
        Uri.parse(api),
        headers: {'Content-Type': 'application/json'},
        body: payload,
      ).timeout(const Duration(seconds: 30));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          _detectedSentence = result['predicted_sentence'];
          _predictions = List<String>.from(result['predictions']);
        });
        print('Predicted sentence: $_detectedSentence');
      } else {
        throw Exception('Server error: ${response.statusCode}\n${response.body}');
      }
    } catch (e) {
      print('Error during detection: $e');
      _showErrorDialog('Failed to detect sign language: $e');
    } finally {
      _isDetecting = false;
      setState(() {});
    }
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
                              _predictions[0],
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

                ///Switch Button
                cameras.length > 1
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SafeArea(
                          child: FloatingActionButton(
                            onPressed: () {

                              startDetection();


                              // setState(() {
                              //   direction = direction == 0 ? 1 : 0;
                              //   startCamera(direction);
                              // });
                            },
                            child: Icon(
                              Icons.flip_camera_ios,
                              color: primaryColor,
                            ),
                            shape: CircleBorder(),
                            backgroundColor: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      )
                    : SizedBox(),
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
