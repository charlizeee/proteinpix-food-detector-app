import 'dart:io';
import 'package:flutter/material.dart';
import '../model/DetectedPhoto.dart';
import '../utils/ClassData.dart';
import '../utils/text.dart';

class DetailedView extends StatelessWidget {
  final DetectedPhoto photoResults;

  const DetailedView({
    Key? key,
    required this.photoResults,
  }) : super(key: key);
  

  Widget showResults(double initialFraction) {
    final maxSize = initialFraction < 0.5 ? 0.5 : initialFraction;
    List<FoodClassInfo> foods = photoResults.results
        .map((e) => foodClassMetadata[e['tag']]!)
        .whereType<FoodClassInfo>()
        .toList();

    Map<String, String> foodCategoryImages = {
      'Fruits/Vegetables': 'Fruits_Vegetables',
      'Meats': 'Meats',
      'Carbs/Grains': 'Carbs_Grains',
      'Sugary Drinks': 'Sugary_Drinks',
    };

    Color secondColor = Color(0xFF21564a);

    return DraggableScrollableSheet(
      initialChildSize: initialFraction,
      minChildSize: initialFraction,
      maxChildSize: maxSize,
      builder: (ctx, sc) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: Column(
            children: [
              // handle & draggable content
              Container(
                width: 40,
                height: 5,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: sc,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Column(
                    children: [
                      SizedBox(width: 8,),

                      IntrinsicWidth(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: secondColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.local_fire_department, color: Colors.white, size: 22),
                              const SizedBox(width: 6),
                              Text(
                                "Total Protein: ${photoResults.totalProtein}g",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 8,),

                      //list of food
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: foods.length,
                        itemBuilder: (ctx, index) {
                          final food = foods[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            color: food.color.withOpacity(0.65), // original color
                            child: ListTile(
                              contentPadding: const EdgeInsets.only(left: 24, right: 36, bottom: 2, top: 2),
                              leading: CircleAvatar(
                                backgroundImage: AssetImage('assets/images/category/${foodCategoryImages[food.category] ?? 'default_image'}.png'),
                              ),
                              subtitle: Text(food.category, style: TextStyle(color: Colors.white60),),
                              trailing: Text("${food.protein.toStringAsFixed(1)} g", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white60),),
                              title: Text(food.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: buildTextSpan("Detailed View", Colors.white, 20),
        ),
        backgroundColor: const Color(0xFF21564a),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenW = constraints.maxWidth;
          final screenH = constraints.maxHeight;

          final imgW = photoResults.imageWidth.toDouble();
          final imgH = photoResults.imageHeight.toDouble();
          final imgRatio = imgW / imgH;
          final screenRatio = screenW / screenH;

          double renderedW, renderedH;

          // Compute scaled image size
          if (imgRatio > screenRatio) {
            renderedW = screenW;
            renderedH = screenW / imgRatio;
          } else {
            renderedH = screenH;
            renderedW = screenH * imgRatio;
          }

          const double overlapPx = 40.0;
          final leftoverFrac = ((screenH - renderedH) / screenH).clamp(0.0, 1.0);
          final initialFraction = (leftoverFrac + overlapPx / screenH).clamp(0.0, 1.0);

          return Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: renderedW,
                  height: renderedH,
                  child: Image.file(
                    File(photoResults.imagePath),
                    width: renderedW,
                    height: renderedH,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              showResults(initialFraction),
            ],
          );
        },
      ),
    );
  }
}
