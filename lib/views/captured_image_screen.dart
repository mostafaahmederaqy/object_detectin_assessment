import 'dart:io';
import 'package:flutter/material.dart';

class CapturedImageScreen extends StatefulWidget {
  final File imageFile;
  final String timestamp;

  const CapturedImageScreen({
    Key? key,
    required this.imageFile,
    required this.timestamp,
  }) : super(key: key);

  @override
  State<CapturedImageScreen> createState() => _CapturedImageScreenState();
}

class _CapturedImageScreenState extends State<CapturedImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Captured Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display image
            //if (imageFile.existsSync())
              Image.file(
                widget.imageFile,
                fit: BoxFit.cover,
                height: 300,
              ),
           /* else
              const Text('Image not found'),*/

            const SizedBox(height: 16),

            // Display timestamp
            Text(
              'Timestamp: ${widget.timestamp}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
