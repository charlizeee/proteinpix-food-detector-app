import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class StepGuideScreen extends StatefulWidget {
  const StepGuideScreen({super.key});

  @override
  _StepGuideScreenState createState() => _StepGuideScreenState();
}

class _StepGuideScreenState extends State<StepGuideScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;
  final Color myPrimaryColor = Color(0xFF21564a);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                isLastPage = index == 2;
              });
            },
            children: [
              _stepPage(
                image: "assets/images/capture.png",
                title: "📸 Capture or Upload",
                description: TextSpan(
                  children: [
                    TextSpan(text: "Snap a photo of your "),
                    TextSpan(
                      text: "single-serving meals",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: " or upload one from your gallery."),
                  ],
                ),
              ),
              _stepPage(
                image: "assets/images/analyze.png",
                title: "🤖 AI Analysis",
                description: TextSpan(
                  text: "AI will scan the image and detect the food items.",
                ),
              ),
              _stepPage(
                image: "assets/images/results.png",
                title: "📊 See Your Results",
                description: TextSpan(
                  children: [
                    TextSpan(text: "View the total protein content and a breakdown of each food item, based on "),
                    TextSpan(
                      text: "expert nutritionist",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: " data."),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: isLastPage
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myPrimaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text("Done", style: TextStyle(fontSize: 18, color: Colors.white)),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => _controller.animateToPage(
                          2,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        ),
                        child: Text("Skip", style: TextStyle(color: myPrimaryColor)),
                      ),
                      SmoothPageIndicator(
                        controller: _controller,
                        count: 3,
                        effect: WormEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          dotColor: Colors.grey.shade300,
                          activeDotColor: myPrimaryColor,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward, color: myPrimaryColor),
                        onPressed: () {
                          _controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _stepPage({
    required String image,
    required String title,
    required TextSpan description,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, width: 250),
          SizedBox(height: 30),
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text.rich(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
