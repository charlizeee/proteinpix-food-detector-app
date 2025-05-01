import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../model/DetectedPhoto.dart';

Future<File> _getFile() async {
  final dir = await getApplicationDocumentsDirectory();
  print("THIS IS THE DIRECTORY: ${dir}");
  return File('${dir.path}/detected_photos.json');
}

Future<void> savePhotosToFile(List<DetectedPhoto> photos) async {
  final file = await _getFile();
  final jsonList = photos.map((e) => e.toJson()).toList();
  await file.writeAsString(jsonEncode(jsonList));
}

Future<List<DetectedPhoto>> loadPhotosFromFile() async {
  final file = await _getFile();
  if (!(await file.exists())) return [];
  final jsonString = await file.readAsString();
  final List<dynamic> jsonList = jsonDecode(jsonString);
  return jsonList.map((e) => DetectedPhoto.fromJson(e)).toList();
}
