import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'HomePage.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;
  Color myPrimaryColor = Color(0xFF609478);

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

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
              _onboardingPage(
                image: "assets/images/onboarding1.png",
                title: "📸 Take a photo of your meal!",
                description: "Track your food quickly and easily with just one tap.",
              ),
              _onboardingPage(
                image: "assets/images/onboarding2.png",
                title: "🍚 Know what’s on your plate.",
                description: "AI detects your food and gives instant protein insights.",
              ),
              _onboardingPage(
                image: "assets/images/onboarding3.png",
                title: "👌 Make healthier choices effortlessly!",
                description: "See your protein intake over time and stay on track with your goals.",
              ),
            ],
          ),
          
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: isLastPage
                ? ElevatedButton(
                    onPressed: completeOnboarding,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myPrimaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text("Get Started", style: TextStyle(fontSize: 18, color: Colors.white)),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Skip Button
                      TextButton(
                        onPressed: () => _controller.animateToPage(
                          2,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        ),
                        child: Text("Skip", style: TextStyle(color: myPrimaryColor),),
                      ),

                      /// Page Indicator
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

                      /// Next Button
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

  Widget _onboardingPage({
    required String image,
    required String title,
    required String description,
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
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
