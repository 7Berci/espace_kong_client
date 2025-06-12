// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espace_kong/home_folder/navigation_drawer.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import '../pressing_folder/home_pressing_screen.dart';
import 'home_culture_screen.dart';
import 'package:url_launcher/url_launcher.dart';

Color eclatColor = const Color(0xFF5ACC80);

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeView createState() => HomeView();
}

class HomeView extends State<Home> {
  int index = 0;
  // final userr = UserPreferences.myUser;

  final screens = const [
    HomePressing(),
    HomeCulture(),
  ];

  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
      drawer: const MyNavigationDrawer(),
      appBar: AppBar(
        backgroundColor: eclatColor,
        title: const Center(
            // child: Text('Que voulez-vous laver ?')
            child: Text('Espace Kong',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ))),
        actions: [
          IconButton(
              onPressed: () => launchUrl(Uri.parse("tel://0707104044")),
              // Navigator.of(context)
              //     .pushReplacement(MaterialPageRoute(builder: (context) => Shop()));
              icon: const Icon(Icons.call)),
        ],
      ),
      
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.white,
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() => this.index = index),
          height: 60.0,
          backgroundColor:
              // userr.isDarkMode ? Colors.grey.shade900 : Colors.white,
              eclatColor,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.local_laundry_service),
              label: 'Pressing',
            ),
            NavigationDestination(
              icon: Icon(Icons.museum),
              label: 'Culture',
            ),
          ],
        ),
      ),
      //     ),
      //   ),
      // ),
    );
  }
}
