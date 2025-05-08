import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart'; 
import 'package:path_provider/path_provider.dart'; 
import '../model/DetectedPhoto.dart'; 
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<void> zipAndShare(List<DetectedPhoto> photos) async {
  EasyLoading.show(status: "Zipping photos...");

  final archive = Archive();

  //add files 
  for (var photo in photos) {
    final file = File(photo.imagePathOrig);
    if (await file.exists()) {
      final fileName = p.basename(file.path);
      final bytes = await file.readAsBytes();
      archive.addFile(ArchiveFile('images/$fileName', bytes.length, bytes));
    }
  }

  // zip data
  final zipData = ZipEncoder().encode(archive);

  try {
    
    final appDocDir = await getApplicationDocumentsDirectory();
    final zipFile = File('${appDocDir.path}/photos.zip');

    //save zip to app directory
    await zipFile.writeAsBytes(zipData);

    EasyLoading.showSuccess("Zipped file ready to share!");

    // share
    await shareZipFile(zipFile);
  } catch (e) {
    print("Error while zipping or saving file: $e");
  }
}

Future<void> shareZipFile(File zipFile) async {
  try {
    await Share.shareXFiles(
      [XFile(zipFile.path, mimeType: 'application/zip')], 
      text: 'Here is your zip file of your detections!',
    );
  } catch (e) {
    print("Error while sharing the file: $e");
  }
}
