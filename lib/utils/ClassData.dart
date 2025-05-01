import 'package:flutter/material.dart';

class FoodClassInfo {
  final String name;
  final double protein;
  final Color color;
  final String imagePath;
  final String category;

  const FoodClassInfo({
    required this.name,
    required this.protein,
    required this.color,
    required this.imagePath,
    required this.category,
  });
}

// Category Colors
const Color meatColor = Color(0xFFD22B2B);
const Color fruitsVegColor = Color(0xFF5F8575);
const Color carbsGrainsColor = Color(0xFFD2B48C);
const Color sugaryDrinksColor = Color(0xFF80461B);

final Map<String, FoodClassInfo> foodClassMetadata = {
  'adobo': FoodClassInfo(
    name: "Adobo",
    protein: 14.5,
    color: meatColor,
    imagePath: "assets/images/food/adobo.png",
    category: "Meats",
  ),
  'banana': FoodClassInfo(
    name: "Banana",
    protein: 1.2,
    color: fruitsVegColor,
    imagePath: "assets/images/food/banana.png",
    category: "Fruits/Vegetables",
  ),
  'chicken_inasal': FoodClassInfo(
    name: "Inasal",
    protein: 36.3,
    color: meatColor,
    imagePath: "assets/images/food/inasal.png",
    category: "Meats",
  ),
  'chopsuey': FoodClassInfo(
    name: "Chopsuey",
    protein: 2.7,
    color: fruitsVegColor,
    imagePath: "assets/images/food/chopsuey.png",
    category: "Fruits/Vegetables",
  ),
  'french_fries': FoodClassInfo(
    name: "French Fries",
    protein: 3.7,
    color: carbsGrainsColor,
    imagePath: "assets/images/food/fries.png",
    category: "Carbs/Grains",
  ),
  'fried_chicken': FoodClassInfo(
    name: "Fried Chicken",
    protein: 40.3,
    color: meatColor,
    imagePath: "assets/images/food/friedchicken.png",
    category: "Meats",
  ),
  'hotdog': FoodClassInfo(
    name: "Hotdog",
    protein: 8.0,
    color: meatColor,
    imagePath: "assets/images/food/hotdog.png",
    category: "Meats",
  ),
  'iced_tea': FoodClassInfo(
    name: "Iced Tea",
    protein: 0.0,
    color: sugaryDrinksColor,
    imagePath: "assets/images/food/icedtea.png",
    category: "Sugary Drinks",
  ),
  'latte': FoodClassInfo(
    name: "Latte",
    protein: 2.81,
    color: sugaryDrinksColor,
    imagePath: "assets/images/food/latte.png",
    category: "Sugary Drinks",
  ),
  'monggo': FoodClassInfo(
    name: "Monggo",
    protein: 1.0,
    color: fruitsVegColor,
    imagePath: "assets/images/food/monggo.png",
    category: "Fruits/Vegetables",
  ),
  'bread': FoodClassInfo(
    name: "Bread",
    protein: 7.9,
    color: carbsGrainsColor,
    imagePath: "assets/images/food/bread.png",
    category: "Carbs/Grains",
  ),
  'mango': FoodClassInfo(
    name: "Mango",
    protein: 0.4,
    color: fruitsVegColor,
    imagePath: "assets/images/food/mango.png",
    category: "Fruits/Vegetables",
  ),
  'scrambled_egg': FoodClassInfo(
    name: "Scrambled Egg",
    protein: 8.25,
    color: meatColor,
    imagePath: "assets/images/food/scrambled.png",
    category: "Meats",
  ),
  'sinangag': FoodClassInfo(
    name: "Sinangag",
    protein: 2.6,
    color: carbsGrainsColor,
    imagePath: "assets/images/food/sinangag.png",
    category: "Carbs/Grains",
  ),
  'sisig': FoodClassInfo(
    name: "Sisig",
    protein: 9.41,
    color: meatColor,
    imagePath: "assets/images/food/sisig.png",
    category: "Meats",
  ),
  'spaghetti ': FoodClassInfo(
    name: "Spaghetti",
    protein: 5.94,
    color: carbsGrainsColor,
    imagePath: "assets/images/food/spaghetti.png",
    category: "Carbs/Grains",
  ),
  'sunny_side_up': FoodClassInfo(
    name: "Sunny Side Up",
    protein: 8.0,
    color: meatColor,
    imagePath: "assets/images/food/sunny.png",
    category: "Meats",
  ),
  'soda': FoodClassInfo(
    name: "Soda",
    protein: 0.0,
    color: sugaryDrinksColor,
    imagePath: "assets/images/food/soda.png",
    category: "Sugary Drinks",
  ),
  'sliced_watermelon': FoodClassInfo(
    name: "Watermelon",
    protein: 0.6,
    color: fruitsVegColor,
    imagePath: "assets/images/food/watermelon.png",
    category: "Fruits/Vegetables",
  ),
  'rice': FoodClassInfo(
    name: "Rice",
    protein: 2.7,
    color: carbsGrainsColor,
    imagePath: "assets/images/food/rice.png",
    category: "Carbs/Grains",
  ),
};
