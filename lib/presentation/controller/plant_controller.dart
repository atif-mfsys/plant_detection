import 'dart:io';
import 'package:get/get.dart';
import '../../domain/entities/plant.dart';
import '../../domain/usecases/detect_plant_usecase.dart';

class PlantController extends GetxController {
  final DetectPlantUseCase detectPlantUseCase;
  var plant = Rxn<Plant>();
  var isLoading = false.obs;

  PlantController(this.detectPlantUseCase);

  Future<void> detect(File image) async {
    isLoading.value = true;
    plant.value = await detectPlantUseCase(image);
    isLoading.value = false;
  }
}
