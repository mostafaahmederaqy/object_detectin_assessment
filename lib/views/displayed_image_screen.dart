import 'dart:io';

import 'package:flutter/material.dart';

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
            ? RotatedBox(quarterTurns: -90, child: Image.file(imageFile))
            : Text('Image not found'),
      ),
    );
  }
}
