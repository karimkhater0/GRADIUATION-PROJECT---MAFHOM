import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:developer';

void main() => runApp(STTScreen());

class STTScreen extends StatefulWidget {
  @override
  _STTScreenState createState() => _STTScreenState();
}

class _STTScreenState extends State<STTScreen> {
  late CameraController _cameraController;
  List<CameraDescription>? cameras;
  bool isDetecting = false;
  String recognizedAction = "";

  @override
  void initState() {
    super.initState();
    initializeCamera();
    loadModel();
  }

  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras != null && cameras!.isNotEmpty) {
        _cameraController =
            CameraController(cameras![0], ResolutionPreset.medium);
        await _cameraController.initialize();
        setState(() {});
        _cameraController.startImageStream((CameraImage img) {
          if (!isDetecting) {
            isDetecting = true;
            runInference(img).then((_) {
              isDetecting = false;
            });
          }
        });
      } else {
        log("No cameras available");
      }
    } catch (e) {
      log("Error initializing camera: $e");
    }
  }

  Future<void> loadModel() async {
    try {
      String? res = await Tflite.loadModel(
        model: 'assets/models/model.tflite',
        labels: 'assets/models/labels.txt',
      );
      log("Model loaded: $res");
      log("><<<<<<<<<<<<<<<<><>><><>><<><>><><<><><><><><><>><");
    } catch (e) {
      log("Error loading model: $e");
    }
  }

  Future<void> runInference(CameraImage img) async {
    try {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: img.planes.map((plane) => plane.bytes).toList(),
        imageHeight: img.height,
        imageWidth: img.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90, // Adjust rotation as needed
        numResults: 1,
        threshold: 0.1,
        asynch: true,
      );

      if (recognitions != null && recognitions.isNotEmpty) {
        setState(() {
          recognizedAction = recognitions[0]['label'];
        });
      }
    } catch (e) {
      log("Error running inference: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cameras == null || !_cameraController.value.isInitialized) {
      return MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            CameraPreview(_cameraController),
            Positioned(
              bottom: 32,
              left: 32,
              right: 32,
              child: Container(
                color: Colors.white.withOpacity(0.7),
                child: Text(
                  recognizedAction,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    Tflite.close();
    super.dispose();
  }
}
