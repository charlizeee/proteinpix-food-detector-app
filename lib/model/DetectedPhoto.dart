class DetectedPhoto {
  String imagePath;
  List<Map<String, dynamic>> results;
  final DateTime timestamp;
  double imageWidth;
  double imageHeight;
  double totalProtein;
  
  DetectedPhoto(this.imagePath, this.results, this.timestamp, this.imageHeight, this.imageWidth, this.totalProtein);

   Map<String, dynamic> toJson() => {
    'imagePath': imagePath,
    'results': results,
    'timestamp': timestamp.toIso8601String(),
    'imageWidth': imageWidth,
    'imageHeight': imageHeight,
    'totalProtein': totalProtein,
  };

  static DetectedPhoto fromJson(Map<String, dynamic> json) => DetectedPhoto(
    json['imagePath'],
    List<Map<String, dynamic>>.from(json['results']),
    DateTime.parse(json['timestamp']),
    json['imageHeight'],
    json['imageWidth'],
    json['totalProtein'],
  );
}

