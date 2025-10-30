import 'dart:io';
import '../entities/plant.dart';
import '../../data/repository/plant_repository_impl.dart';

class DetectPlantUseCase {
  final PlantRepositoryImpl repository;

  DetectPlantUseCase(this.repository);

  Future<Plant> call(File image) => repository.detectPlant(image);
}
