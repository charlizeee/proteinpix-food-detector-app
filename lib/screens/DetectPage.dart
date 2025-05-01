import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../provider/ObjectProvider.dart';
import '../model/DetectedPhoto.dart';
import '../utils/ClassData.dart';
import '../utils/PolygonPainter.dart';
import 'package:path_provider/path_provider.dart';

class DetectPage extends StatefulWidget {
  final String imagePath;
  const DetectPage({super.key, required this.imagePath});

  @override
  State<DetectPage> createState() => _DetectPageState();
}

class _DetectPageState extends State<DetectPage> {
  final FlutterVision vision = FlutterVision();
  List<Map<String, dynamic>> results = [];
  late File imageFile;
  bool isLoaded = false;
  bool hasDetected = false;
  int imageHeight = 1;
  int imageWidth = 1;
  bool isDetecting = true;
  bool confirmed = false;
  final GlobalKey _renderKey = GlobalKey();
  int? selectedPolygonIndex;
  Color whenTapped = Color(0xFFffdc85);
  Color myPrimaryColor = Color(0xFF90b79e);
  Color secondColor = Color(0xFF21564a);

  Map<String, String> foodCategoryImages = {
    'Fruits/Vegetables': 'Fruits_Vegetables',
    'Meats': 'Meats',
    'Carbs/Grains': 'Carbs_Grains',
    'Sugary Drinks': 'Sugary_Drinks',
  };

  @override
  void initState() {
    super.initState();
    imageFile = File(widget.imagePath);
    loadModel();
  }

  // This function is called when the page is initialized.
  Future<void> loadModel() async {
    try {
      await vision.loadYoloModel(
        labels: 'assets/labels/labels.txt',
        modelPath: 'assets/models/float16.tflite',
        modelVersion: "yolov8seg",
        quantization: false,
        numThreads: 4,
        useGpu: true,
      );
      setState(() => isLoaded = true);
      
      runSegmentation();
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to load model: $e");
      print("Error here: ${e}");
    }
  }

  Future<void> runSegmentation() async {

    print("Running YOLOv8 Segmentation...");

    Uint8List bytes = await imageFile.readAsBytes();
    final decodedImage = await decodeImageFromList(bytes);
    imageHeight = decodedImage.height;
    imageWidth = decodedImage.width;

    if (imageHeight <= 0 || imageWidth <= 0) {
      Fluttertoast.showToast(msg: "Image could not be processed properly.");
      return;
    }

    print("Image size: $imageWidth x $imageHeight");

    final output = await vision.yoloOnImage(
      bytesList: bytes,
      imageHeight: imageHeight,
      imageWidth: imageWidth,
      iouThreshold: 0.4,
      confThreshold: 0.4,
      classThreshold: 0.4,
    );

    for (var result in output) {
      print("Tag: ${result["tag"]} (${result["tag"].runtimeType})");
      print("Box: ${result["box"]} (${result["box"].runtimeType})");
      print("Polygons: ${result["polygons"]} (${result["polygons"].runtimeType})");
    }

    print("Detection completed. Found ${output.length} objects.");
    print("Results: $output");

    if (output.isEmpty) {
      Fluttertoast.showToast(msg: "No objects detected.");
      setState(() {
        isDetecting = false;
      });
    } else {
      EasyLoading.showSuccess('Success! Found ${output.length} food item(s).');
      setState(() {
        results = output;
        hasDetected = true;
      });
    }
  }

  List<Widget> drawSegmentationBoxes(double factorX, double factorY) {
    if (results.isEmpty) return [];
    return results.map((result) {
      final box = result["box"] as List<dynamic>;
      final tag = result["tag"] as String;
      if (!foodClassMetadata.containsKey(tag)) return SizedBox.shrink();

      final isSelected = selectedPolygonIndex == results.indexOf(result);
      Color color = isSelected 
          ? whenTapped.withOpacity(0.2)
          : foodClassMetadata[tag]!.color.withOpacity(0.5);

      return Positioned(
        left: box[0] * factorX,
        top: box[1] * factorY,
        width: (box[2] - box[0]) * factorX,
        height: (box[3] - box[1]) * factorY,
        child: CustomPaint(
          key: ValueKey("${tag}_${results.indexOf(result)}"),
          painter: PolygonPainter(
            polygonColor: color,
            points: (result["polygons"] as List)
              .map((e) {
                final xy = Map<String,double>.from(e);
                xy['x'] = xy['x']! * factorX;
                xy['y'] = xy['y']! * factorY;
                return xy;
              })
              .toList(),
          ),
        ),
      );
    }).toList();
  }

  Widget showLoadingImage(){
    final screenSize = MediaQuery.of(context).size;
    
    return Container(
      key: const ValueKey("loading"),
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/loading.png", 
            width: screenSize.width * 0.75,
            height: screenSize.width * 0.75,
          ),
          const SizedBox(height: 20),
          const Text(
            "Detecting food...",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget showImageWithButton(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.file(
            imageFile,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }

  // compute for total protein content
  double get totalProtein => results.fold<double>(
    0.0,
    (sum, item) {
      final info = foodClassMetadata[item['tag']];
      return sum + (info?.protein ?? 0.0);
    },
  );

  void editClassAt(int index) async {
    final currentTag = results[index]['tag'];
    final selectedTag = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select New Class'),
          content: DropdownButton<String>(
            value: currentTag,
            isExpanded: true,
            items: foodClassMetadata.keys.map((tag) {
              return DropdownMenuItem(
                value: tag,
                child: Text(foodClassMetadata[tag]?.name ?? tag),
              );
            }).toList(),
            onChanged: (value) {
              Navigator.of(context).pop(value);
            },
          ),
        );
      },
    );

    if (selectedTag != null && selectedTag != currentTag) {
      setState(() {
        results[index]['tag'] = selectedTag;
      });
      Fluttertoast.showToast(msg: "Class updated to $selectedTag");
    }
  }


  Widget showResults(double initialFraction){
    final maxSize = initialFraction < 0.5 ? 0.5 : initialFraction;

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

                      // Total protein circle
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(color: myPrimaryColor, shape: BoxShape.circle,),
                        alignment: Alignment.center,
                        child: Text(totalProtein.toStringAsFixed(1),
                          style: TextStyle(
                              color: secondColor, fontSize: 26, fontWeight: FontWeight.w600),
                        ),
                      ),

                      const SizedBox(height: 4),
                      const Text("Total Protein Content",style: TextStyle(color: Colors.black54, fontSize: 12)),
                      const SizedBox(height: 10),

                      // Show list of detected items
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),  
                        shrinkWrap: true,
                        itemCount: results.length,
                        itemBuilder: (ctx, index) {
                          final item = results[index];
                          final info = foodClassMetadata[item['tag']];
                          if (info == null) return const SizedBox();

                          final bool isSelected = selectedPolygonIndex == index;

                          return GestureDetector(
                            onTap: () async {
                              setState(() {
                                selectedPolygonIndex = index; // show highlight
                              });

                              await Future.delayed(Duration(milliseconds: 150));

                              setState(() {
                                selectedPolygonIndex = null; // remove the highlight and go back 
                              });
                            },

                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              color: isSelected
                                    ? whenTapped // selected color
                                    : info.color.withOpacity(0.65),  // orig
                              child: ListTile(
                                leading: CircleAvatar(
                                  // backgroundImage: AssetImage(info.imagePath),
                                  backgroundImage: AssetImage('assets/images/category/${foodCategoryImages[info.category] ?? 'default_image'}.png'),
                                ),
                                title: Text(info.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                                subtitle: Text("${info.protein.toStringAsFixed(1)} g",
                                  style: TextStyle(fontSize: 12, color: Colors.white60)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, color: Colors.white70),
                                      onPressed: () {
                                        confirmed ? null : editClassAt(index);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.white70),
                                      onPressed: confirmed
                                          ? null
                                          : () {
                                              setState(() {
                                                results.removeAt(index);
                                              });
                                              Fluttertoast.showToast(msg: "Detection removed");
                                            },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),


                      const SizedBox(height: 8),

                      // Confirm button
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secondColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: confirmed
                          ? null
                          : () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Confirm Detections'),
                                content: const Text('Are you sure you want to lock in these detections?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop(); 
                                    },
                                    child: Text('No',style: TextStyle(color: secondColor)),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF21564a), 
                                      foregroundColor: Colors.white, 
                                    ),
                                    onPressed: () {
                                      Fluttertoast.showToast(msg: "Confirmed");
                                      setState(() {
                                        confirmed = true;
                                      });
                                      Navigator.of(ctx).pop();
                                    },
                                    child: const Text('Yes'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text("Confirm Detections",
                              style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),),
                        ),
                      ),
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
        backgroundColor: myPrimaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton (
              onPressed: () async {
                if (results.isEmpty) {
                  Fluttertoast.showToast(msg: "No detection to save.");
                  return;
                }

                if (!confirmed) {
                  Fluttertoast.showToast(msg: "Please confirm detections first.");
                  return;
                }

                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  EasyLoading.show(status: "Saving detection...");
                  RenderRepaintBoundary boundary =
                      _renderKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

                  // Capture image
                  var image = await boundary.toImage(pixelRatio: 3.0);
                  ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);

                  if (byteData == null) {
                    Fluttertoast.showToast(msg: "Failed to capture image.");
                    return;
                  }

                  Uint8List pngBytes = byteData.buffer.asUint8List();

                  // new file path
                  // final directory = await Directory.systemTemp.createTemp(); 
                  final directory = await getApplicationDocumentsDirectory();
                  final String newPath = '${directory.path}/detection_${DateTime.now().millisecondsSinceEpoch}.png';
                  final File newImageFile = File(newPath);

                  await newImageFile.writeAsBytes(pngBytes);

                  final timestamp = DateTime.now();

                  // Save the detection
                  final detectedPhoto = DetectedPhoto(
                    newPath, 
                    widget.imagePath,  
                    results, 
                    timestamp,
                    imageHeight.toDouble(), 
                    imageWidth.toDouble(),  
                    totalProtein,           
                    );
                  Provider.of<ObjectProvider>(context, listen: false).addDetectedPhoto(detectedPhoto);
                  
                  EasyLoading.showSuccess('Success!');
                  Navigator.pop(context);
                });
              },

              icon: Icon(Icons.save_alt_rounded, color: secondColor,),
            ),
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: (isLoaded && hasDetected)
            ? LayoutBuilder(
                key: const ValueKey("results"),
                builder: (context, constraints) {
                  final screenW = constraints.maxWidth;
                  final screenH = constraints.maxHeight;

                  final imgW = imageWidth.toDouble();
                  final imgH = imageHeight.toDouble();
                  final imgRatio = imgW / imgH;
                  final screenRatio = screenW / screenH;

                  double renderedW, renderedH;

                  // compute scaled image size
                  if (imgRatio > screenRatio) {
                    renderedW = screenW;
                    renderedH = screenW / imgRatio;
                  } else {
                    renderedH = screenH;
                    renderedW = screenH * imgRatio;
                  }

                  final factorX = renderedW / imgW;
                  final factorY = renderedH / imgH;

                  // compute for the remaining space for the draggable sheet
                  const double overlapPx = 40.0;
                  final leftoverFrac = ((screenH - renderedH) / screenH).clamp(0.0, 1.0);
                  final initialFraction = (leftoverFrac + overlapPx / screenH)
                      .clamp(0.0, 1.0);

                  return Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: renderedW,
                          height: renderedH,
                          child: RepaintBoundary(
                            key: _renderKey,
                            child: Stack(
                              children: [
                                // image
                                Image.file(
                                  imageFile,
                                  width: renderedW,
                                  height: renderedH,
                                  fit: BoxFit.fill,
                                ),
                                // segmentation mask
                                ...drawSegmentationBoxes(factorX, factorY),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // draggable sheet outside the boundary
                      showResults(initialFraction),
                    ],
                  );
                },
              )
            : (isDetecting)
                ? showLoadingImage()
                : showImageWithButton(),
      ),
    );
  }
}