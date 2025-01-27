import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import '../helpers/convert_image_to_file.dart';
import '../views/displayed_image_screen.dart';

Future<void> captureAndNavigate(CameraImage image) async {
  try {
    final capturedImage = await convertCameraImageToFile(image);

    Get.to(() => DisplayCapturedImageScreen(imageFile: capturedImage));
  } catch (e) {
    log('Error capturing image: $e');
  }
}
