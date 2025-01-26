import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../views/captured_image_screen.dart'; // Import the screen where captured images are displayed

class ScanProvider extends ChangeNotifier {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;

  bool _isCameraInitialized = false;
  int _cameraCount = 0;

  double x = 0.0, y = 0.0, w = 0.0, h = 0.0;
  String label = '';
  String _message = '';

  bool get isCameraInitialized => _isCameraInitialized;
  String get message => _message;
  CameraController get cameraController => _cameraController;

  Future<void> initCamera(BuildContext context,String selectedObject) async {
    if (await Permission.camera.request().isGranted) {
      _cameras = await availableCameras();
      _cameraController = CameraController(_cameras[0], ResolutionPreset.max);

      // Initialize TensorFlow Lite model
      await initTflite();

      await _cameraController.initialize().then((_) {
        _cameraController.startImageStream((image) {
          _cameraCount++;
          if (_cameraCount % 10 == 0) {
            _cameraCount = 0;
            objectDetector(context, image,selectedObject); // Pass context here
          }
          notifyListeners();
        });
      });

      _isCameraInitialized = true;
      notifyListeners();
    } else {
      log('Camera permission denied');
    }
  }

  Future<void> initTflite() async {
    await Tflite.loadModel(
      model: 'assets/ssd_mobilenet.tflite',
      labels: 'assets/ssd_mobilenet.txt',
      isAsset: true,
      numThreads: 1,
      useGpuDelegate: false,
    );
    log('TensorFlow Lite model loaded successfully.');
  }

  Future<void> objectDetector(BuildContext context, CameraImage image,String selectedObject) async {
    var detector = await Tflite.detectObjectOnFrame(
      bytesList: image.planes.map((e) => e.bytes).toList(),
      asynch: true,
      imageHeight: image.height,
      imageWidth: image.width,
      numResultsPerClass: 1,
      rotation: 0,
      threshold: 0.4,
    );

    if (detector != null && detector.isNotEmpty) {
      log('Result: $detector');

      var detectedObject ;

      for (var value in detector) {
        if(value['detectedClass']==selectedObject){
          detectedObject=value;
          if (detectedObject['confidenceInClass'] * 100 > 45) {
            label = detectedObject['detectedClass'].toString();
            print(selectedObject);
              print('hiiiiiiiiiiii');
              h = detectedObject['rect']['h'];
              w = detectedObject['rect']['w'];
              x = detectedObject['rect']['x'];
              y = detectedObject['rect']['y'];

              if (h > 0.5 || w > 0.5) {
                _message = "Move farther";
              } else if (h < 0.2 || w < 0.2) {
                _message = "Move closer";
              } else {
                _message = "Object in position";
                captureAndNavigate(context, image); // Use context here
              }
          }
        }
        else{
          y = 0.0;
        }
      }


      notifyListeners();
    }
  }

  Future<void> captureAndNavigate(BuildContext context, CameraImage image) async {
    try {
      final capturedImage = await convertCameraImageToFile(image);
      final timestamp = DateTime.now().toString(); // Capture the current timestamp

      // Navigate to the CapturedImageScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CapturedImageScreen(
            imageFile: capturedImage,
            timestamp: timestamp,
          ),
        ),
      );
    } catch (e) {
      log('Error capturing image: $e');
    }
  }

  Future<File> convertCameraImageToFile(CameraImage image) async {
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/captured_image.jpg';

    try {
      final img.Image rgbImage = _convertYUV420ToImage(image);
      final jpg = img.JpegEncoder().encodeImage(rgbImage);

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

        final int uvRow = row ~/ 2;
        final int uvCol = col ~/ 2;
        final int uvIndex = uvRow * uvRowStride + uvCol * uvPixelStride;

        final int y = yPlane[yIndex];
        final int u = uPlane[uvIndex];
        final int v = vPlane[uvIndex];

        final int r = (y + 1.402 * (v - 128)).clamp(0, 255).toInt();
        final int g = (y - 0.344136 * (u - 128) - 0.714136 * (v - 128))
            .clamp(0, 255)
            .toInt();
        final int b = (y + 1.772 * (u - 128)).clamp(0, 255).toInt();

        rgbImage.setPixel(col, row, img.getColor(r, g, b));
      }
    }

    return rgbImage;
  }

  @override
  void dispose() {
    print('kdmsckmdsamkmksamksacmk');
    _cameraController.dispose();

    super.dispose();
  }
}
