import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

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
