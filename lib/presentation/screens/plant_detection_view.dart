import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/plant_controller.dart';

class PlantDetectionView extends StatelessWidget {
  final picker = ImagePicker();
  final controller = Get.find<PlantController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Plant Detector 🌿')),
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return CircularProgressIndicator();
          } else if (controller.plant.value != null) {
            final plant = controller.plant.value!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Plant: ${plant.name}', style: TextStyle(fontSize: 20)),
                Text('Disease: ${plant.disease}', style: TextStyle(fontSize: 18)),
                Text('Confidence: ${(plant.confidence * 100).toStringAsFixed(2)}%'),
              ],
            );
          } else {
            return ElevatedButton(
              onPressed: () async {
                final image = await picker.pickImage(source: ImageSource.camera);
                if (image != null) controller.detect(File(image.path));
              },
              child: Text('Capture Plant'),
            );
          }
        }),
      ),
    );
  }
}
