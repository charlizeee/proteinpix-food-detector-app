class DetectedPhoto {
  String imagePath;
  String imagePathOrig;
  List<Map<String, dynamic>> results;
  final DateTime timestamp;
  double imageWidth;
  double imageHeight;
  double totalProtein;
  
  DetectedPhoto(this.imagePath, this.imagePathOrig, this.results, this.timestamp, this.imageHeight, this.imageWidth, this.totalProtein);

   Map<String, dynamic> toJson() => {
    'imagePath': imagePath,
    'imagePathOrig': imagePathOrig,
    'results': results,
    'timestamp': timestamp.toIso8601String(),
    'imageWidth': imageWidth,
    'imageHeight': imageHeight,
    'totalProtein': totalProtein,
  };

  static DetectedPhoto fromJson(Map<String, dynamic> json) => DetectedPhoto(
    json['imagePath'],
    json['imagePathOrig'],
    List<Map<String, dynamic>>.from(json['results']),
    DateTime.parse(json['timestamp']),
    json['imageHeight'],
    json['imageWidth'],
    json['totalProtein'],
  );
}

