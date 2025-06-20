// ignore: depend_on_referenced_packages
import 'package:espace_kong/home_folder/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'forgotpassword_page.dart';
import 'signin_withphone_page.dart';
import 'signup_widget.dart';
import 'utils.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginWidget({super.key, required this.onClickedSignUp});

  @override
  LoginWidgetState createState() => LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Utils utilsWidget = Utils();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 2.0),
          ftkLogo(200.0),
          const SizedBox(height: 2.0),
          const Text(
            "Bon retour !",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          TextField(
            controller: emailController,
            // cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: passwordController,
            // cursorColor: Colors.white,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(labelText: 'Mot de passe'),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: signIn,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: ftkColor,
              // side: BorderSide(
              //   color: ftkColor, // Border color
              //   width: 2, // Border width
              // ),
            ),
            icon: const Icon(Icons.lock_open, size: 32, color: Colors.white),
            label: const Text(
              "Se connecter",
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            child: Text(
              "Mot de passe oublié ?",
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            onTap:
                () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ForgotPasswordPage(),
                  ),
                ),
          ),
          const SizedBox(height: 50.0),
          Text("Pas de compte ?", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed:
                  widget.onClickedSignUp, // Your function to switch to sign up
              icon: Icon(Icons.person_add, color: Colors.white),
              label: Text(
                "S'inscrire",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          // RichText(
          //   text: TextSpan(
          //     style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
          //     text: 'Pas de compte ?  ',
          //     children: [
          //       TextSpan(
          //         recognizer:
          //             TapGestureRecognizer()..onTap = widget.onClickedSignUp,
          //         text: "S'inscrire",
          //         style: TextStyle(
          //           decoration: TextDecoration.underline,
          //           color: Colors.black,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          const SizedBox(height: 90),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (builder) => const LoginAdmin()),
              );
            },
            //     () {
            //   Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(builder: (builder) => AdminScreen()));
            // },
            child: const Text(''),
            // style: ElevatedButton.styleFrom(
            //   padding: const EdgeInsets.symmetric(vertical: 15),
            //   primary: Colors.white,
            // ),
          ),
        ],
      ),
    ),
  );
  Future signIn() async {
    EasyLoading.show(status: 'Connexion...');
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      EasyLoading.dismiss();
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (builder) => Home()));
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      SnackBar(content: Text(e.message ?? "Erreur"));
      //utilsWidget.showSnackBar(e.message);
    }
    // Future signIn() async {
    //   showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) => const Center(child: CircularProgressIndicator()),
    //   );
    //   try {
    //     await FirebaseAuth.instance.signInWithEmailAndPassword(
    //       email: emailController.text.trim(),
    //       password: passwordController.text.trim(),
    //     );
    //   } on FirebaseAuthException catch (e) {
    //     // ignore: avoid_print
    //     print(e);

    //     utilsWidget.showSnackBar(e.message);
    //     Navigator.pop(context);
    //   }

    //   // //Navigator.of(context) not working!
    //   // navigatorKey.currentState!.popUntil((route) => route.isFirst);
    //   //isFirst
    //   Navigator.of(
    //     context,
    //   ).pushReplacement(MaterialPageRoute(builder: (builder) => Home()));
    // }
  }
}
