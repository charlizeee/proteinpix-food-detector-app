import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/DetectPage.dart';
import 'screens/HomePage.dart';
import 'screens/HistoryPage.dart';
import 'screens/DetailedView.dart';
import 'screens/ClassList.dart';
import 'screens/OnboardingScreen.dart';
import 'screens/StepGuideScreen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import '../provider/ObjectProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ObjectProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_complete') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: hasSeenOnboarding(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        final bool seenOnboarding = snapshot.data ?? false;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: EasyLoading.init(),
          title: "Protein Tracker",
          home: seenOnboarding ? HomePage() : OnboardingScreen(),
          initialRoute: '/',
          onGenerateRoute: (settings) {
            if (settings.name == '/') {
              return MaterialPageRoute(builder: (context) => HomePage());
            } else if (settings.name == '/history'){
              return MaterialPageRoute(builder: (context) => HistoryPage());
            } else if (settings.name == '/detail'){
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) => DetailedView(photoResults: args['photoResults'])
              );
            } else if (settings.name == '/foodClasses'){
              return MaterialPageRoute(builder: (context) => ClassList());
            } 
            else if (settings.name == '/stepGuide'){
              return MaterialPageRoute(builder: (context) => StepGuideScreen());
            } 
            else if (settings.name == '/detect') {
              final args = settings.arguments as Map<String, dynamic>;
              return MaterialPageRoute(
                builder: (context) => DetectPage(imagePath: args['imagePath'])
              );
            } 
            return null;
          },
        );
      },
    );
  }
}
