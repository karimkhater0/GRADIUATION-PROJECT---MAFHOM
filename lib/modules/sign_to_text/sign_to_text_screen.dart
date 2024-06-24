import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class STTScreen extends StatefulWidget {
  @override
  _SignLanguageDetectionScreenState createState() =>
      _SignLanguageDetectionScreenState();
}

class _SignLanguageDetectionScreenState extends State<STTScreen> {
  CameraController? _controller;
  bool _isDetecting = false;
  bool _isCapturing = false;
  bool _isLoading = false;
  String _detectedSentence = '';
  List<String> _predictions = [];
  List<XFile> _frameBuffer = [];
  Timer? _timer;
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      _logger.d('Available cameras: ${cameras.length}');
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      _logger.d('Selected camera: ${frontCamera.name}');
      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await _controller!.initialize();

      await _controller!.setZoomLevel(1.0);

      await _controller!.setExposureMode(ExposureMode.auto);

      await _controller!.setFlashMode(FlashMode.auto);

      _logger.d('Camera initialized');
      if (!mounted) return;
      setState(() {});
      _startDetection();
    } catch (e) {
      _logger.e('Error initializing camera: $e');
      _showErrorDialog('Failed to initialize camera: $e');
    }
  }

  void _startDetection() {
    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (!_isDetecting && !_isCapturing) {
        _captureFrame();
      }
    });
  }

  Future<void> _captureFrame() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _isCapturing) {
      return;
    }
    _isCapturing = true;
    try {
      final image = await _controller!.takePicture();
      _addFrameToBuffer(image);
    } catch (e) {
      _logger.e('Error capturing frame: $e');
    } finally {
      _isCapturing = false;
    }
  }

  void _addFrameToBuffer(XFile image) {
    _frameBuffer.add(image);
    if (_frameBuffer.length >= 30) {
      _detectSequence();
    }
  }

  Future<void> _detectSequence() async {
    if (_isDetecting) return;
    _isDetecting = true;
    setState(() => _isLoading = true);
    try {
      List<String> base64Frames = [];
      for (var frame in _frameBuffer.sublist(_frameBuffer.length - 30)) {
        final bytes = await frame.readAsBytes();
        final base64Image = base64Encode(bytes);
        base64Frames.add(base64Image);
      }

      final payload = jsonEncode({
        'frames': base64Frames,
      });

      final response = await http
          .post(
            Uri.parse('http://192.168.1.13:5000/predict_sequence'),
            headers: {'Content-Type': 'application/json'},
            body: payload,
          )
          .timeout(Duration(seconds: 30)); // Increase timeout to 30 seconds

      _logger.d('Response status: ${response.statusCode}');
      _logger.d('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          _detectedSentence = result['predicted_sentence'];
          _predictions = List<String>.from(result['predictions']);
        });
      } else {
        _logger.e('Server error: ${response.statusCode}');
        _showErrorDialog(
            'Server error occurred: ${response.statusCode}\n${response.body}');
      }
    } catch (e) {
      _logger.e('Error during detection: $e');
      _showErrorDialog('Failed to detect sign language: $e');
    } finally {
      setState(() {
        _isDetecting = false;
        _isLoading = false;
      });
      _frameBuffer.clear();
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
    _timer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return Scaffold(
      // appBar: AppBar(title: Text('Sign Language Detection')),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: CameraPreview(_controller!),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Detected Sentence:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(_detectedSentence, style: TextStyle(fontSize: 16)),
                SizedBox(height: 16),
                Text('Recent Predictions:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(_predictions.join(', '), style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
