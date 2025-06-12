import '../home_folder/home.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
                  "Nous sommes à notre service pour offrir un service de qualité.",
              image: buildImage('assets/images/onBoard2.png'),
              decoration: getPageDecoration,
            ),
            PageViewModel(
              title: 'Lavage à sec et repassage',
              body: 'Gardez vos vêtements propres et secs',
              image: buildImage('assets/images/onBoard3.png'),
              decoration: getPageDecoration,
            ),
            PageViewModel(
              title: 'Offres adaptées à tous types de budgets',
              body:
                  'Les hôtels et structures bénéficient de tarifs particuliers',
              image: buildImage('assets/images/onBoard5.png'),
              decoration: getPageDecoration,
            ),
            PageViewModel(
              title: 'Un pressing autrement',
              body:
                  "Les abonnés premium FTK Pressing bénéficient de livraisons gratuites !",
              image: buildImage('assets/images/onBoard6.png'),
              decoration: getPageDecoration,
            ),
          ],
          done: const Text('Commencer',
              style: TextStyle(fontWeight: FontWeight.bold)),
          onDone: () async {
            goToHome(context);
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool('showHome', true);
          },
          showSkipButton: true,
          skip: const Text('Passer'),
          // skipFlex: 0,
          // nextFlex: 0,
          onSkip: () => goToHome(context),
          next: const Icon(Icons.arrow_forward),
          dotsDecorator: getDotDecoration(),
          // isProgress: false,
          // isProgressTap: false,
          // animationDuration: 1000,
        ),
      );

  void goToHome(context) =>
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => StreamBuilder<User?>(
                stream: _auth.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Erreur'));
                  } else {
                    return snapshot.data == null
                        ? const AuthPage()
                        : const Home();
                    // return snapshot.data == null
                    //     ? const SignInView()
                    //     : const Shop();
                  }
                },
              )));

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));
}

DotsDecorator getDotDecoration() => DotsDecorator(
      color: const Color(0xFF5ACC80),
      activeColor: Colors.yellow,
      size: const Size(10, 10),
      activeSize: const Size(22, 10),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    );

const getPageDecoration = PageDecoration(
  titleTextStyle:
      TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
  bodyTextStyle: TextStyle(fontSize: 20),
  // descriptionPadding: EdgeInsets.all(16).copyWith(bottom: 0),
  imagePadding: EdgeInsets.all(24),
  pageColor: Color(0xFF5ACC80),
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