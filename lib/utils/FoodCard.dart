import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  final String name;
  final double protein;
  final String imagePath;

  const FoodCard({
    super.key,
    required this.name,
    required this.protein,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Let's use a percentage of the card height for font size
        final double baseHeight = constraints.maxHeight;
        final double nameFontSize = baseHeight * 0.07; 
        final double proteinFontSize = baseHeight * 0.05; 

        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: nameFontSize,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF175753),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${protein.toString()}g protein",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: proteinFontSize,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
