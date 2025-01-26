import 'package:flutter/material.dart';
import 'camera_view_ref.dart';

class ObjectSelectionScreen extends StatefulWidget {
  const ObjectSelectionScreen({Key? key}) : super(key: key);

  @override
  State<ObjectSelectionScreen> createState() => _ObjectSelectionScreenState();
}

class _ObjectSelectionScreenState extends State<ObjectSelectionScreen> {
  String? selectedObject; // Stores the selected object

  final List<String> objects = ['laptop', 'cell phone', 'mouse', 'bottle']; // Object list

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select an Object'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Select the object you want to detect:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            // Object selection
            Expanded(
              child: ListView.builder(
                itemCount: objects.length,
                itemBuilder: (context, index) {
                  final object = objects[index];
                  return ListTile(
                    title: Text(object),
                    leading: Radio<String>(
                      value: object,
                      groupValue: selectedObject,
                      onChanged: (value) {
                        setState(() {
                          selectedObject = value;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Get Started button
            ElevatedButton(
              onPressed: selectedObject != null
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraView(selectedObject: selectedObject!),
                  ),
                );
              }
                  : null, // Disable button if no object is selected
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
