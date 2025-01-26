/*import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:object_detection_assessment_solution/controllers/scan_controller.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ScanController>(
        init: ScanController(),
        builder: (controller) {
          return controller.isCameraInitialized.value?
          Stack(
            children: [
              CameraPreview(controller.cameraController),
              Positioned(
                top: controller.y*700,
                right: controller.x*500,
                child: Container(
                  width: controller.w*100*context.width/100,
                  height: controller.h*100*context.height/100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.green,
                      width: 4.0
                    )
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          color: Colors.white,
                          child: Text(controller.label),
                      )
                    ],
                  ),
                ),
              )
            ],
          ):
          const Center(child: Text('loading preview ...'));
        }
      ),
    );
  }
}*/
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/scan_controller.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ScanController>(
          init: ScanController(),
          builder: (controller) {
            return controller.isCameraInitialized.value
                ? Column(
                  children: [
                    Stack(
                    children: [
                    CameraPreview(controller.cameraController),
                    controller.y==null?SizedBox():Positioned(
                      top: controller.y * context.height,
                      right: controller.x * context.width,
                      child: Container(
                        width: controller.w * 100 * context.width / 100,
                        height: controller.h * 100 * context.height / 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border:
                            Border.all(color: Colors.green, width: 4.0)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              color: Colors.white,
                              child: Text(controller.label),
                            )
                          ],
                        ),
                      ),
                    )
                                  ],
                                ),

                    Text(
                      controller.message.value,
                      style: TextStyle(fontSize: 18, color: Colors.red),
                      textAlign: TextAlign.center,
                    )
                  ],
                )
                : const Center(child: Text('loading preview ...'));
          }),
    );
  }
}