import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/ObjectProvider.dart';
import '../model/DetectedPhoto.dart';
import '../utils/text.dart';

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
        backgroundColor: Color(0xFF90b79e),
      ),
      body: detectedPhotos.isEmpty
        ? showNohistory(screen)
        : showSavedDetections(detectedPhotos.reversed.toList()),
    );
  }

  Widget showSavedDetections(List<DetectedPhoto> detectedPhotos) {
    return ListView.builder(
      itemCount: detectedPhotos.length,
      itemBuilder: (context, index) {
        DetectedPhoto photo = detectedPhotos[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/detail', arguments: {'photoResults': photo});
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center, // <-- center all vertically
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
                      mainAxisAlignment: MainAxisAlignment.center, // <- ensures vertical centering
                      children: [
                        Text(
                          "Detected on ${photo.timestamp.toLocal().toString().split(' ')[0]}",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 2),
                        Text("${photo.results.length} object(s) detected"),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}