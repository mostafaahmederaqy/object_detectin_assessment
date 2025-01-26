/*import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController{


  @override
  void onInit() {
    super.onInit();
    initCamera();
    initTflite();
  }


  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

late CameraController cameraController;
late List<CameraDescription> cameras;

var isCameraInitialized=false.obs;
var cameraCount=0;
var x,y,w,h=0.0;
var label='';

initCamera()async{
  if(await Permission.camera.request().isGranted){
    cameras = await availableCameras();
    cameraController=CameraController(cameras[0], ResolutionPreset.max);
    await cameraController.initialize().then((value){
        cameraController.startImageStream((image){
          cameraCount++;
          if(cameraCount %10==0){
            cameraCount=0;
            objectDetector(image);
          }
          update();
        });

    });
    isCameraInitialized(true);
    update();
  }else{
    print('permission denied');
  }
}

initTflite() async{
  await Tflite.loadModel(model: 'assets/ssd_mobilenet.tflite',
  labels: 'assets/ssd_mobilenet.txt',
    isAsset: true,
    numThreads: 1,
    useGpuDelegate: false
  );
}

objectDetector(CameraImage image)async {
  var detector=await Tflite.detectObjectOnFrame(bytesList: image.planes.map((e){
    return e.bytes;
  }).toList(),
  asynch: true,
    imageHeight: image.height,
    imageWidth: image.width,
    imageMean: 127.5,
    imageStd: 127.5,
    numResultsPerClass: 1,
    //numBoxesPerBlock: 1,
    //numResults: 1,
    rotation: 90,
    threshold: 0.4
  );

  if(detector !=null){
    print('hji');
    print(detector);
    if(detector.isNotEmpty){
      var ourDetectedObject=detector.first;
      if(ourDetectedObject['confidenceInClass']*100>45){

        label=ourDetectedObject['detectedClass'].toString();
        if(label=='laptop'){
          h=ourDetectedObject['rect']['h'];
          w=ourDetectedObject['rect']['w'];
          x=ourDetectedObject['rect']['x'];
          y=ourDetectedObject['rect']['y'];
          log('result is $detector');
        }

      }
    }
    update();
  }


}

}*/

import 'dart:developer';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';

class ScanController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initCamera();
    initTflite();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
    Tflite.close();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;

  var isCameraInitialized = false.obs;
  var cameraCount = 0;
  var x, y, w, h = 0.0;
  var label = '';
  var message = ''.obs;


  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      cameraController = CameraController(cameras[0], ResolutionPreset.max);
      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 10 == 0) {
            cameraCount = 0;
            objectDetector(image);
          }
          update();
        });
      });
      isCameraInitialized(true);
      update();
    } else {
      print('permission denied');
    }
  }

  initTflite() async {
    await Tflite.loadModel(
        model: 'assets/ssd_mobilenet.tflite',
        labels: 'assets/ssd_mobilenet.txt',
        isAsset: true,
        numThreads: 1,
        useGpuDelegate: false);
  }

  objectDetector(CameraImage image) async {
    var detector = await Tflite.detectObjectOnFrame(
        bytesList: image.planes.map((e) {
          return e.bytes;
        }).toList(),
        asynch: true,
        imageHeight: image.height,
        imageWidth: image.width,
        //imageMean: 127.5,
        //imageStd: 127.5,
        numResultsPerClass: 1,
        //numBoxesPerBlock: 1,
        //numResults: 1,
        rotation: 0,
        threshold: 0.4);

    if (detector != null) {
      print('hji');
      print(detector);
      if (detector.isNotEmpty) {
        log('result is $detector');
        var ourDetectedObject = detector.first;
        if (ourDetectedObject['confidenceInClass'] * 100 > 55) {
          label = ourDetectedObject['detectedClass'].toString();
          if (label == 'mouse') {
            h = ourDetectedObject['rect']['h'];
            w = ourDetectedObject['rect']['w'];
            x = ourDetectedObject['rect']['x'];
            y = ourDetectedObject['rect']['y'];
            if (h > 0.5 || w > 0.5) {
              print('Move farther');
              message.value = "Move farther";
            } else if (h < 0.2 || w < 0.2) {
              print('Move closer');
              message.value = "Move closer";
            } else {
              message.value = "Object in position";
              captureAndNavigate(image);
            }
           // captureAndNavigate(image);
          } else {
            y = null;
          }
        }
      }
      update();
    }
  }



  Future<void> captureAndNavigate(CameraImage image) async {
    try {
      final capturedImage = await convertCameraImageToFile(image);

      Get.to(() => DisplayCapturedImageScreen(imageFile: capturedImage));
    } catch (e) {
      log('Error capturing image: $e');
    }
  }

  Future<File> convertCameraImageToFile(CameraImage image) async {
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/captured_image.jpg';

    try {
      // Convert YUV420 to RGB
      final img.Image rgbImage = _convertYUV420ToImage(image);

      // Encode RGB image to JPEG
      final jpg = img.JpegEncoder().encodeImage(rgbImage);

      // Save to file
      final imageFile = File(path);
      await imageFile.writeAsBytes(jpg);

      return imageFile;
    } catch (e) {
      throw Exception('Error converting image: $e');
    }
  }

  img.Image _convertYUV420ToImage(CameraImage image) {
    final int width = image.width;
    final int height = image.height;

    final img.Image rgbImage = img.Image(width, height);

    final Uint8List yPlane = image.planes[0].bytes;
    final Uint8List uPlane = image.planes[1].bytes;
    final Uint8List vPlane = image.planes[2].bytes;

    final int uvRowStride = image.planes[1].bytesPerRow;
    final int uvPixelStride = image.planes[1].bytesPerPixel ?? 1;

    for (int row = 0; row < height; row++) {
      for (int col = 0; col < width; col++) {
        final int yIndex = row * image.planes[0].bytesPerRow + col;

        // Calculate UV indices
        final int uvRow = row ~/ 2;
        final int uvCol = col ~/ 2;
        final int uvIndex = uvRow * uvRowStride + uvCol * uvPixelStride;

        final int y = yPlane[yIndex];
        final int u = uPlane[uvIndex];
        final int v = vPlane[uvIndex];

        // Convert YUV to RGB
        final int r = (y + 1.402 * (v - 128)).clamp(0, 255).toInt();
        final int g = (y - 0.344136 * (u - 128) - 0.714136 * (v - 128))
            .clamp(0, 255)
            .toInt();
        final int b = (y + 1.772 * (u - 128)).clamp(0, 255).toInt();

        // Set the pixel in the RGB image
        rgbImage.setPixel(col, row, img.getColor(r, g, b));
      }
    }

    return rgbImage;
  }
}

class DisplayCapturedImageScreen extends StatelessWidget {
  final File imageFile;

  const DisplayCapturedImageScreen({Key? key, required this.imageFile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(imageFile.path);
    return Scaffold(
      appBar: AppBar(title: Text('Captured Image')),
      body: Center(
        child: imageFile.existsSync()
            ? RotatedBox(quarterTurns: -90,
            child: Image.file(imageFile))
            : Text('Image not found'),
      ),
    );
  }
}