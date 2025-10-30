import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../../domain/entities/plant.dart';

class PlantRepositoryImpl {
  late Interpreter _interpreter;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/model.tflite');
  }

  Future<Plant> detectPlant(File imageFile) async {
    final imageBytes = await imageFile.readAsBytes();
    final img.Image? image = img.decodeImage(imageBytes);
    if (image == null) throw Exception("Invalid image");

    // Resize and normalize image (adjust based on model input size)
    final resized = img.copyResize(image, width: 224, height: 224);
    var input = List.generate(
        1, (i) => List.generate(224, (j) => List.generate(224, (k) => [0.0])));

    for (int x = 0; x < 224; x++) {
      for (int y = 0; y < 224; y++) {
        final pixel = resized.getPixel(x, y);
        input[0][x][y][0] = (img.getLuminance(pixel)) / 255.0;
      }
    }

    // Prepare output tensor (adjust size to match model)
    var output =
        List.filled(1 * 38, 0.0).reshape([1, 38]); // 38 classes (example)

    _interpreter.run(input, output);

    // Find the most confident class
    int index = output[0].indexOf(output[0].reduce((a, b) => a > b ? a : b));
    double confidence = output[0][index];

    // Replace with your own label list
    List<String> labels = [
      "Apple Healthy",
      "Apple Scab",
      "Corn Healthy",
      "Corn Rust",
      // ...
    ];

    final label = labels[index];
    final parts = label.split(' ');
    final plant = parts[0];
    final disease = parts.length > 1 ? parts.sublist(1).join(' ') : 'Healthy';

    return Plant(name: plant, disease: disease, confidence: confidence);
  }
}

