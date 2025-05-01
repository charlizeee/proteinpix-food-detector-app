import 'package:flutter/material.dart';
import '../model/DetectedPhoto.dart';
import '../services/photoStorage.dart';

class ObjectProvider with ChangeNotifier {
  List<DetectedPhoto> _detectedPhotos = [];
  final List<DetectedPhoto> _recentDetections = [];

  List<DetectedPhoto> get detectedPhotos => _detectedPhotos;
  List<DetectedPhoto> get recentDetections =>
    _detectedPhotos.reversed.take(4).toList();

  Future<void> loadPhotos() async {
    // deleteDetectedPhotosFile();
    _detectedPhotos = await loadPhotosFromFile();

    if (_detectedPhotos.isNotEmpty) {
      _recentDetections.insert(0, _detectedPhotos.last);
    }

    if (_recentDetections.length > 4) {
      _recentDetections.removeLast();
    }

    notifyListeners();
  }

  Future<void> addDetectedPhoto(DetectedPhoto photo) async {
    _detectedPhotos.add(photo);

    _recentDetections.insert(0, photo);
    if (_recentDetections.length > 4) {
      _recentDetections.removeLast();
    }

    await savePhotosToFile(_detectedPhotos);
    notifyListeners();
  }

  Future<void> clearPhotos() async {
    _detectedPhotos.clear();
    _recentDetections.clear();
    await savePhotosToFile(_detectedPhotos);
    notifyListeners();
  }

  Future<void> removePhoto(int index) async {
    final removed = _detectedPhotos.removeAt(index);
    _recentDetections.remove(removed);
    await savePhotosToFile(_detectedPhotos);
    notifyListeners();
  }
}
