import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'data/repository/plant_repository_impl.dart';
import 'domain/usecases/detect_plant_usecase.dart';
import 'presentation/controller/plant_controller.dart';
import 'presentation/screens/plant_detection_view.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final data = await rootBundle.load('assets/model.tflite');
  // print('Model bytes length: ${data.lengthInBytes}');
  final repository = PlantRepositoryImpl();
  await repository.loadModel();

  final useCase = DetectPlantUseCase(repository);
  Get.put(PlantController(useCase));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: PlantDetectionView(),
    );
  }
}
