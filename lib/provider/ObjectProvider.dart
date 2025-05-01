import 'package:flutter/material.dart';
import '../model/DetectedPhoto.dart';
import '../services/photoStorage.dart';

class ObjectProvider with ChangeNotifier {

  ObjectProvider() {
    loadPhotos(); 
  }

  List<DetectedPhoto> _detectedPhotos = [];
  
  List<DetectedPhoto> get detectedPhotos => _detectedPhotos;
  List<DetectedPhoto> get recentDetections =>
      _detectedPhotos.reversed.take(4).toList();

  Future<void> loadPhotos() async {
    // deleteDetectedPhotosFile(); 
    _detectedPhotos = await loadPhotosFromFile();
    notifyListeners();
  }

  Future<void> addDetectedPhoto(DetectedPhoto photo) async {
    _detectedPhotos.add(photo);
    await savePhotosToFile(_detectedPhotos);
    notifyListeners();
  }

  Future<void> clearPhotos() async {
    _detectedPhotos.clear();
    await savePhotosToFile(_detectedPhotos);
    notifyListeners();
  }

  Future<void> removePhoto(int index) async {
    final removed = _detectedPhotos.removeAt(index);
    await savePhotosToFile(_detectedPhotos);
    notifyListeners();
  }
}
