// ignore: depend_on_referenced_packages
import 'package:email_validator/email_validator.dart';
import 'utils.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_auth_forgot_password/firebase_auth_forgot_password.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  Utils utilsWidget = Utils();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Renitialiser le mot de passe',
            style: TextStyle(
              color: Colors.grey.shade900,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Recevoir un email\npour renitialiser',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                TextFormField(
                    controller: emailController,
                    // cursorColor: Colors.grey.shade900,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(labelText: 'Email'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) {
                      if (email != null &&
                          !EmailValidator.validate(emailController.text)) {
                        return 'Entrez un email valide';
                      } else {
                        return null;
                      }
                    }
                    // ? 'Entrez un email valide'
                    // : null, }
                    ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: resetPassword,
                  icon: const Icon(Icons.email_outlined),
                  label: const Text(
                    'Renitialiser le mot de passe',
                    style: TextStyle(fontSize: 24),
                  ),
                )
              ],
            ),
          ),
        ),
      );

  Future resetPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      utilsWidget.showSnackBar('Mail de récupération de mot de passe envoyé');
      // ignore: use_build_context_synchronously
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);

      utilsWidget.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}
