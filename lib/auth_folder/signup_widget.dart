import 'package:espace_kong/auth_folder/enter_number.dart';

import 'signin_withphone_page.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:email_validator/email_validator.dart';

class SignUpWidget extends StatefulWidget {
  final Function() onClickedSignIn;

  const SignUpWidget({
    super.key,
    required this.onClickedSignIn,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
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
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              afEclatLogo(200.0),
              const SizedBox(height: 20),
              const Text(
                "Bienvenu !",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              const Text(
                "Inscrivez-vous si vous n'avez pas encore de compte, sinon cliquez sur se connecter !",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Email'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Entrez un email valide'
                        : null,
                // cursorColor: Colors.black,
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? 'Entrez au moins 6 caractères'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: signUp,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                icon: const Icon(Icons.arrow_forward, size: 32),
                label: const Text(
                  "S'inscrire",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(height: 20),
              // Row(
              //   children: [
              //     Text('Déjà un compte ? '),
              //     TextButton(
              //       onPressed: () {
              //         Navigator.of(context).pushReplacement(MaterialPageRoute(
              //             builder: (builder) => LoginWidget()));
              //       },
              //       child: Text(
              //         "Se connecter",
              //         style: const TextStyle(
              //           decoration: TextDecoration.underline,
              //           color: Theme.of(context).colorScheme.secondary,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              RichText(
                  text: TextSpan(
                style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                text: 'Déjà un compte ?   ',
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickedSignIn,
                    text: "Se connecter",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              )),
              const SizedBox(height: 24),

              // Column(
              //   children: [
              //     Text(
              //       "Pour l'authentification par numéro téléphonique, ",
              //       style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
              //     ),
              //     TextButton(all(8.0)
              //       onPressed: () {
              //         Navigator.of(context).push(MaterialPageRoute(
              //             builder: (builder) => const SignInView()));
              //       },
              //       child: Text(
              //         "Cliquez-ici",
              //         style: TextStyle(
              //           decoration: TextDecoration.underline,
              //           color: Theme.of(context).colorScheme.primary,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),

              const SizedBox(height: 90),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (builder) => const LoginAdmin()));
                },
                //     () {
                //   Navigator.of(context).pushReplacement(
                //       MaterialPageRoute(builder: (builder) => AdminScreen()));
                // },
                child: const Text(
                  '',
                ),
                // style: ElevatedButton.styleFrom(
                //   padding: const EdgeInsets.symmetric(vertical: 15),
                //   primary: Colors.white,
                // ),
              ),
            ],
          ),
        ),
      ));

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) =>
          const Center(child: CircularProgressIndicator.adaptive()),
    );
    try {
      // UserCredential result =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // User? user = result.user;
      // // user?.displayName = nameController.text.trim();

      // await DatabaseService(uid: user?.uid).updateUserData(
      //   'https://cdn-icons-png.flaticon.com/512/892/892781.png?w=360',
      //   'Client X707',
      //   'number ?',
      //   'location ?',
      //   false,
      // );
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);

      utilsWidget.showSnackBar(e.message);
    }

    //navigatorKey.currentState!.popUntil((route) => route.isFirst);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (builder) => EnterNumber()));
  }
}

Widget afEclatLogo(size) {
  String imagePath = 'assets/images/onBoard6.png';
  return Image.asset(
    imagePath,
    height: size,
    width: size,
  );
}
