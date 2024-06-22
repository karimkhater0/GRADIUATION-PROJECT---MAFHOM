import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: STTScreen(),
    );
  }
}

class STTScreen extends StatefulWidget {
  @override
  _STTScreenState createState() => _STTScreenState();
}

class _STTScreenState extends State<STTScreen> {
  String answer = "";
  CameraController? cameraController;
  CameraImage? cameraImage;
  bool isModelLoaded = false;
  List<CameraDescription>? cameras;
  late Interpreter _interpreter;

  @override
  void initState() {
    super.initState();
    loadModel().then((success) {
      if (success) {
        setupCamera();
      } else {
        print("Failed to load the model. Camera setup aborted.");
      }
    });
  }

  Future<bool> loadModel() async {
    try {
      print("Attempting to load model...");

      _interpreter = await Interpreter.fromAsset('model.tflite');

      var inputShape = _interpreter.getInputTensor(0).shape;
      var outputShape = _interpreter.getOutputTensor(0).shape;
      var inputType = _interpreter.getInputTensor(0).type;
      var outputType = _interpreter.getOutputTensor(0).type;

      print("Model input shape: $inputShape");
      print("Model output shape: $outputShape");
      print("Model input type: $inputType");
      print("Model output type: $outputType");

      print("Model loaded successfully");
      setState(() {
        isModelLoaded = true;
      });
      return true;
    } catch (e) {
      print("Error loading model: $e");
      return false;
    }
  }

  void setupCamera() async {
    try {
      print("Attempting to setup camera...");
      cameras = await availableCameras();
      if (cameras != null && cameras!.isNotEmpty) {
        print("Camera found");
        cameraController = CameraController(
          cameras![1], // Selecting the front camera (index 1)
          ResolutionPreset.medium,
        );

        await cameraController!.initialize();
        print("Camera initialized");

        setState(() {});

        cameraController!.startImageStream((CameraImage image) {
          print("Received image from camera");
          if (isModelLoaded) {
            print("Model is loaded, processing image");
            setState(() {
              cameraImage = image;
            });
            applyModelOnImage();
          } else {
            print("Model not loaded yet");
          }
        });
      } else {
        print("No cameras available");
      }
    } catch (e) {
      print("Error setting up camera: $e");
    }
  }

  Future<void> applyModelOnImage() async {
    if (cameraImage != null) {
      try {
        Float32List inputData = preprocessImage(cameraImage!);
        var input = inputData.reshape([1, 30, 1662, 1]);
        var output = List.filled(16, 0.0).reshape([1, 16]);
        _interpreter.run(input, output);

        List<double> results = output[0].sublist(0, 10).cast<double>();

        final List<String> actions = [
          'computers',
          'faculty',
          'Hello',
          'I am',
          'information',
          'student',
          'university',
          'Mansoura',
          'in',
          'and'
        ];

        // Find the index of the highest confidence
        int maxIndex = results.indexOf(results.reduce(math.max));

        String newAnswer =
            '${actions[maxIndex]}: ${results[maxIndex].toStringAsFixed(3)}';

        setState(() {
          answer = newAnswer;
        });
        print("Model applied successfully: $newAnswer");
      } catch (e) {
        print("Error applying model: $e");
      }
    }
  }

  Float32List preprocessImage(CameraImage image) {
    int width = image.width;
    int height = image.height;
    var img = image.planes[0].bytes;

    // Create a buffer of the correct size and type
    var convertedBytes = Float32List(30 * 1662);

    // Resize and normalize the image data
    for (int y = 0; y < 30; y++) {
      for (int x = 0; x < 1662; x++) {
        int srcX = (x * width / 1662).floor();
        int srcY = (y * height / 30).floor();
        int srcIndex = srcY * width + srcX;
        int destIndex = y * 1662 + x;

        // Ensure we don't go out of bounds
        if (srcIndex < img.length && destIndex < convertedBytes.length) {
          // Normalize the pixel value to 0-1 range
          convertedBytes[destIndex] = img[srcIndex] / 255.0;
        }
      }
    }

    return convertedBytes;
  }

  @override
  void dispose() {
    _interpreter.close();
    cameraController?.dispose();
    print("Disposed resources");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[900],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Mafhoom',
                style: TextStyle(
                  fontSize: 45.0,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: cameraController != null &&
                      cameraController!.value.isInitialized
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CameraPreview(cameraController!),
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
            SizedBox(height: 20),
            ResultDisplay(result: answer),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ResultDisplay extends StatelessWidget {
  final String result;

  ResultDisplay({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        result,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.teal[900],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
