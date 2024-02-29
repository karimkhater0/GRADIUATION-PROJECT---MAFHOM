import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mafhom/shared/constants.dart';

class TextToSignCameraScreen extends StatefulWidget {
  TextToSignCameraScreen({super.key});


  @override
  State<TextToSignCameraScreen> createState() => _TextToSignCameraScreenState();
}

class _TextToSignCameraScreenState extends State<TextToSignCameraScreen> {
  late List<CameraDescription> cameras;

  late CameraController cameraController;
  bool isCameraReady = false;

  int direction = 0;

  @override
  void initState() {

    startCamera(0);
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
    Future.delayed(const Duration(seconds: 2),(){
      setState(() {
        isCameraReady=true;
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
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: CameraPreview(cameraController)),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FloatingActionButton(
                    onPressed: (){
                      cameraController.takePicture().then((XFile? file) {
                        if(mounted)
                          {
                             if(file != null){
                               print("Picture saved to ${file.path}");
                             }
                          }
                      });
                    },
                    child: Icon(Icons.camera_sharp,color: Colors.white,),
                    shape: CircleBorder(),
                    backgroundColor: primaryColor,

                  ),
                ),
              ],
            ),
          )
        : Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,);
  }
}
