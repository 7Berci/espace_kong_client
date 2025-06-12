import 'dart:async';
import 'package:flutter/material.dart';

class Slidercarrousel extends StatefulWidget {
  const Slidercarrousel({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SlidercarrouselState();
  }
}

class _SlidercarrouselState extends State<Slidercarrousel> {
  final List<String> images = [
    'assets/images/epressing.jpg',
    'assets/images/epressing1.jpg',
    'assets/images/epressing2.jpg',
  ];
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage < images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth,
      height: screenHeight * 0.3, // Définir une hauteur fixe pour éviter l'infinité
      child: PageView.builder(
        controller: _pageController,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return SizedBox.expand(
            child: Image.asset(
              images[index],
              fit: BoxFit.cover, // Utilisez BoxFit.cover pour que l'image prenne toute la place
            ),
          );
        },
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }
}
