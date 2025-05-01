import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import '../model/DetectedPhoto.dart'; 

Future<String> zipDetectedPhotos(List<DetectedPhoto> photos) async {
  final archive = Archive();

  for (var photo in photos) {
    final file = File(photo.imagePathOrig);
    if (await file.exists()) {
      final fileName = p.basename(file.path);
      final bytes = await file.readAsBytes();
      archive.addFile(ArchiveFile('images/$fileName', bytes.length, bytes));
    }
  }

  final zipData = ZipEncoder().encode(archive);

  //save to download folder
  final downloadsDir = Directory('/storage/emulated/0/Download');
  final zipFile = File('${downloadsDir.path}/detected_photos.zip');
  await zipFile.writeAsBytes(zipData);

  return zipFile.path;
}
