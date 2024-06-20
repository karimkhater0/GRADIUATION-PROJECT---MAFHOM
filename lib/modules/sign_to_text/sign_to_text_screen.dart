import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../shared/constants.dart';

class STTScreen extends StatefulWidget {
  @override
  State<STTScreen> createState() => _STTScreenState();
}

class _STTScreenState extends State<STTScreen> {
  late List<CameraDescription> cameras;

  late CameraController cameraController;

  bool isCameraReady = false;
  int direction = 0;

  @override
  void initState() {
    startCamera(direction);
    // TODO: implement initState
    super.initState();
  }

  void startCamera(int direction) async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras[direction],
      ResolutionPreset.high,
      enableAudio: false,
    );

    await cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((e) {
      print(e);
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isCameraReady = true;
      });
    });
  }

  Future<void> openCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
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
                            padding: const EdgeInsets.only(left: 8.0,top: 8.0,right: 8.0),
                            child: Text(
                              'hi',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox( height: 100 ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SafeArea(
                    child: FloatingActionButton(
                      onPressed: (){
                        setState(() {
                          direction = direction == 0 ? 1 :0;
                          startCamera(direction);
                        });
                      },
                      child: Icon(Icons.cameraswitch,color: Colors.white,),
                      shape: CircleBorder(),
                      backgroundColor: primaryColor,

                    ),
                  ),
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
