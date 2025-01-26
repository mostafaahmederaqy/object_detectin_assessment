import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/scan_provider.dart';

class CameraView extends StatelessWidget {
  final String selectedObject;

  const CameraView({super.key, required this.selectedObject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<ScanProvider>(
         create: (context) => ScanProvider(),
        builder: (context, child) {
           return Consumer<ScanProvider>(
             builder: (context, provider, child) {
               if (!provider.isCameraInitialized) {
                 provider.initCamera(context,selectedObject); // Pass context here
                 return const Center(child: CircularProgressIndicator());
               }

               return Column(
                 children: [
                   Stack(
                     children: [
                       CameraPreview(provider.cameraController),
                       if (provider.y != 0.0)
                         Positioned(
                           top: provider.y * MediaQuery.of(context).size.height,
                           right: provider.x * MediaQuery.of(context).size.width,
                           child: Container(
                             width: provider.w * MediaQuery.of(context).size.width,
                             height: provider.h * MediaQuery.of(context).size.height,
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(8),
                               border: Border.all(color: Colors.green, width: 4.0),
                             ),
                             child: Container(
                               child: Text(provider.label),
                             ),
                           ),
                         ),
                     ],
                   ),
                   Text(
                     provider.message,
                     style: const TextStyle(fontSize: 18, color: Colors.red),
                     textAlign: TextAlign.center,
                   ),
                 ],
               );
             },
           );
        },

      ),
    );
  }
}
