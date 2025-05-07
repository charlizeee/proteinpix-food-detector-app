import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import '../utils/ClassData.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/text.dart';
import 'package:provider/provider.dart';
import '../provider/ObjectProvider.dart';
import '../model/DetectedPhoto.dart';
import '../services/zipPhotos.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  double screenWidth = 0;
  double screenHeight = 0;
  Color myPrimaryColor = Color(0xFF90b79e); //0xFF609478 0xFF175753 - dark
  Color secondColor = Color(0xFF21564a);
  
  Future<void> _openCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      Navigator.pushNamed(context, '/detect', arguments: {'imagePath': pickedFile.path});
    }
  }

  Future<void> _openGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Navigator.pushNamed(context, '/detect', arguments: {'imagePath': pickedFile.path});
    }
  }

  Widget appText(String text1, Color color1, String text2, Color color2) {
    return RichText(
      text: TextSpan(
        children: [
          buildTextSpan(text1, color1, 24),
          buildTextSpan(text2, color2, 24),
        ],
      ),
    );
  }

  Widget classesCard() {
    double imageSize = screenHeight * 0.24;

    return GestureDetector(
      onTap: () {},
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            color: myPrimaryColor,
            child: Container(
              height: screenHeight * 0.20,
              child: Row(
                children: [
                  SizedBox(width: imageSize), 
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 16.0, top: 8.0, bottom: 8.0),  
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '${foodClassMetadata.length} ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFDD57E), // Yellowish number
                                  ),
                                ),
                                TextSpan(
                                  text: 'Filipino Food Classes',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // Normal white text
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: secondColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/foodClasses');
                              },
                              child: Text(
                                "View Now",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Overflowing image
          Positioned(
            top: -imageSize * 0.18,
            left: 0,
            child: Image.asset(
              'assets/images/mascot.png',
              height: imageSize,
              width: imageSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget showRecentDetections(List<DetectedPhoto> recentDetections) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0),
        child: recentDetections.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/norecent.png",
                      width: screenWidth * 0.45,
                    ),
                    Text(
                      "Nothing to show.\nTake a photo to get started!",
                      style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 134, 133, 133)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : Column(
                children: List.generate(2, (rowIndex) {
                  return Expanded(
                    child: Row(
                      children: List.generate(2, (colIndex) {
                        int index = rowIndex * 2 + colIndex;
                        if (index >= recentDetections.length) {
                          return Expanded(child: SizedBox());
                        }
                        final detection = recentDetections[index];
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/detail',  arguments: {'photoResults': detection});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    File(detection.imagePath),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ),
      ),
    );
  }

  Widget scanButton() {
    return FloatingActionButton(
      elevation: 0,
      highlightElevation: 0,
      backgroundColor: secondColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      onPressed: () {
        _openCamera();
      },
      child: Icon(Icons.camera_alt_rounded, size: 36, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recentDetections = Provider.of<ObjectProvider>(context).recentDetections;
    final allDetections = Provider.of<ObjectProvider>(context).detectedPhotos;
    final screen = MediaQuery.of(context).size;
    screenWidth = screen.width;
    screenHeight = screen.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondColor,
        title: Row(
          children: [
            appText("Protein", Colors.white, "Pix", Color(0xFFffdc85)),
            Spacer(),
            IconButton( 
              onPressed: () async {
                if (allDetections.isEmpty) {
                  Fluttertoast.showToast(msg: "No detections to download.");
                  return;
                }
                try {
                  EasyLoading.show(status: "Saving detection...");
                  final zipPath = await zipDetectedPhotos(allDetections);
                  EasyLoading.showSuccess('Success! Saved in downloads folder.');
                  print("Zipped file location: $zipPath");
                  
                } catch (e) {
                  Fluttertoast.showToast(msg: "Failed to zip images.");
                  print("Error while zipping: $e");
                }
              },

              icon: Icon(Icons.download, color: Colors.white, )
            ), 
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // quickAccessText("Quick Access"),
            SizedBox(height: 30,),
            classesCard(),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 15, bottom: 5),
              child: Text(
                "Recent Detections",
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3E3E3E),
                ),
              )
            ),
            showRecentDetections(recentDetections),
          ],
        )
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        shape: CircularNotchedRectangle(),
        notchMargin: 0.0,
        color: myPrimaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.upload, color: Colors.black45,),
              onPressed: _openGallery,
            ),
            SizedBox(width: 48), 
            IconButton(
              icon: Icon(Icons.history_rounded, color: Colors.black45),
              onPressed: () {
                Navigator.pushNamed(context, '/history');
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Transform.translate(
        offset: Offset(0, 10), 
        child: SizedBox(
          height: 70,
          width: 70,
          child: scanButton(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
