import 'themes.dart';
import '../auth_folder/utils.dart';
import 'package:flutter/material.dart'; 
import 'onbroding_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Firebase directly here
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDKYzPCZfKCzqEztLYD8vBuTnks7oRD7cQ",
            authDomain: "espace-kong.firebaseapp.com",
            projectId: "espace-kong",
            storageBucket: "espace-kong.firebasestorage.app",
            messagingSenderId: "635951895712",
            appId: "1:635951895712:web:37985cab89d87d61e325c5",
            measurementId: "G-W0TNQYPB5S"
        ),
      );
    }
    
    configLoading();
    runApp(MyApp());
  } catch (e) {
    print("Firebase initialization error: $e");
    // Fallback to run app without Firebase if initialization fails
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Failed to initialize Firebase: $e'),
          ),
        ),
      ),
    );
  }
}
  //final prefs = await SharedPreferences.getInstance();
  //final showHome = prefs.getBool('showHome') ?? false;
  
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}

final navigatorKey = GlobalKey<NavigatorState>();

//Stateless du MaterialApp
// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  // final bool showHome;

 MyApp({super.key});
  static const String title = "Eclat d'Afrik";
  // final userr = UserPreferences.myUser;
  Utils utilsInstance = Utils();

  @override
  Widget build(BuildContext context) => ThemeProvider(
        // initTheme: userr.isDarkMode ? MyThemes.darkTheme : MyThemes.lightTheme,
        initTheme: MyThemes.lightTheme,
        child: Builder(
          builder: (context) => MaterialApp(
            scaffoldMessengerKey: utilsInstance.messengerKey,
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            // theme: ThemeProvider.of(context),
            // theme: userr.isDarkMode ? MyThemes.darkTheme : MyThemes.lightTheme,
            theme: MyThemes.lightTheme,
            title: title,
            home: OnBrodingPage(),
            // home: showHome ? const AuthPage() : OnBrodingPage(),
            builder: EasyLoading.init(),
          ),
        ),
      );
}
