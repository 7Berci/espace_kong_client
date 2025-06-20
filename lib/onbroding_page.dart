import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home_folder/home.dart';
import 'auth_folder/auth_page.dart';

class OnBrodingPage extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  OnBrodingPage({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
    child: IntroductionScreen(
      pages: [
        PageViewModel(
          title: 'Restez chez vous et on vous sert!',
          body:
              "Nous sommes à votre service, disponibles du lundi au samedi, de 8h à 20h, pour vous offrir des services de qualité.",
          image: buildImage('assets/images/onBoard2.png'),
          decoration: getPageDecoration,
        ),
        PageViewModel(
          title: 'Lavage à sec et repassage',
          body:
              'Avec nous, gardez vos vêtements propres, secs, avec une très belle odeur et très bien repassé, tout ça en un seul clic.',
          image: buildImage('assets/images/onBoard3.png'),
          decoration: getPageDecoration,
        ),
        PageViewModel(
          title: 'Offres adaptées à tous types de budgets',
          body:
              '15% de réduction pour 10 articles et 20% pour 20 articles à laver, sans compter les nombreuses surprises pour les abonnés.',
          //body: 'Les hôtels et structures bénéficient de tarifs particuliers',
          image: buildImage('assets/images/onBoard5.png'),
          decoration: getPageDecoration,
        ),
        PageViewModel(
          title: 'Un pressing autrement',
          body:
              "Des solutions extraordinaires vous attendent ! \n Fangan Tech est avec vous pour des solutions utiles et personnalisées.",
          //les futurs abonnés premium FTK Pressing bénéficient de livraisons gratuites !
          image: buildImage('assets/images/onBoard6.jpg'),
          decoration: getPageDecoration,
        ),
      ],
      done: const Text(
        'Commencer',
        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF005C9F)),
      ),
      onDone: () async {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('showHome', true);
        goToHome(context);
      },
      showSkipButton: true,
      skip: const Text('Passer', style: TextStyle(color: Color(0xFF005C9F))),
      // skipFlex: 0,
      // nextFlex: 0,
      onSkip: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('showHome', true);
        goToHome(context);
      },
      next: const Icon(Icons.arrow_forward, color: Color(0xFF005C9F)),
      dotsDecorator: getDotDecoration(),
      // isProgress: false,
      // isProgressTap: false,
      // animationDuration: 1000,
    ),
  );

  void goToHome(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder:
          (_) => StreamBuilder<User?>(
            stream: _auth.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Erreur'));
              } else {
                return snapshot.data == null ? const AuthPage() : const Home();
                // return snapshot.data == null
                //     ? const SignInView()
                //     : const Shop();
              }
            },
          ),
    ),
  );

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));
}

DotsDecorator getDotDecoration() => DotsDecorator(
  color: const Color(0xFF1C89E8),
  activeColor: Color(0xFF005C9F),
  size: const Size(10, 10),
  activeSize: const Size(22, 10),
  activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
);

const getPageDecoration = PageDecoration(
  titleTextStyle: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Color(0xFF005C9F),
  ),
  bodyTextStyle: TextStyle(fontSize: 20),
  // descriptionPadding: EdgeInsets.all(16).copyWith(bottom: 0),
  imagePadding: EdgeInsets.all(24),
  pageColor: Colors.white,
);

// PageDecoration getPageDecoration() => PageDecoration(
//       titleTextStyle: const TextStyle(
//           fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
//       bodyTextStyle: const TextStyle(fontSize: 20),
//       // descriptionPadding: EdgeInsets.all(16).copyWith(bottom: 0),
//       imagePadding: EdgeInsets.all(24),
//       pageColor: eclatColor,
//     );

  // class AuthentificationWrapper extends StatelessWidget {
  //   @override
  //   Widget build(BuildContext context) {
  //     return Shop();
  //   }
  // }