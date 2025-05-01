import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/ObjectProvider.dart';
import '../model/DetectedPhoto.dart';
import '../utils/text.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  Widget showNohistory(Size screen){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/nohistory.png',
            width: screen.width * 0.75,
          ),
          SizedBox(height: 20),
          Text(
            "No images saved yet.",
            style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 134, 133, 133)),
            textAlign: TextAlign.center
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detectedPhotos = Provider.of<ObjectProvider>(context).detectedPhotos;
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: buildTextSpan("History", Colors.white),
        ),
        backgroundColor: Color(0xFF21564a),
      ),
      body: detectedPhotos.isEmpty
        ? showNohistory(screen)
        : showSavedDetections(detectedPhotos.reversed.toList()),
    );
  }

  Widget showSavedDetections(List<DetectedPhoto> detectedPhotos) {
    Color cardColor = Color(0xFF90b79e);
    Color text = Colors.black;
    return ListView.builder(
      padding: EdgeInsets.only(top: 8),
      itemCount: detectedPhotos.length,
      itemBuilder: (context, index) {
        DetectedPhoto photo = detectedPhotos[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/detail', arguments: {'photoResults': photo});
          },
          child: Card(
            color: cardColor,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center, 
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(photo.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [
                        Text(
                          "Detected on ${DateFormat('MMMM d').format(photo.timestamp.toLocal())}",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: text),
                        ),
                        const SizedBox(height: 2),
                        Text("${photo.results.length} object(s) detected", style: TextStyle(color: text.withOpacity(0.5)),),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: text),
                    onPressed: () async {
                      final confirm = await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text("Delete Entry"),
                          content: Text("Are you sure you want to delete this detection?"),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: Text("Cancel", style: TextStyle(color: Color(0xFF21564a)),)),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF21564a), 
                                foregroundColor: Colors.white, 
                              ),
                              onPressed: () {
                                Fluttertoast.showToast(msg: "Confirmed");
                                Navigator.pop(context, true);
                              },
                              child: Text("Delete")
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        Provider.of<ObjectProvider>(context, listen: false).removePhoto(index);
                      }
                    },
                  ),

                ],
              ),
            ),
          ),
        );
      }
    );
  }
}