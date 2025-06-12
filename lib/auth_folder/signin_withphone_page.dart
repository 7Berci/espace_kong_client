import 'package:flutter/gestures.dart';
import 'function.dart';
import 'utils.dart';
import 'package:flutter/material.dart';
import 'auth_page.dart';
import 'verification_otp.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:intl_phone_field/intl_phone_field.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  bool loading = false;
  String phoneNumber = '';
  void sendOtpCode() {
    loading = true;
    setState(() {});
    // ignore: no_leading_underscores_for_local_identifiers
    final _auth = FirebaseAuth.instance;
    if (phoneNumber.isNotEmpty) {
      authWithPhoneNumber(phoneNumber, onCodeSend: (verificationId, v) {
        loading = false;
        setState(() {});
        Navigator.of(context).push(MaterialPageRoute(
            builder: (c) => VerificationOtp(
                  verificationId: verificationId,
                  phoneNumber: phoneNumber,
                )));
      }, onAutoVerify: (v) async {
        await _auth.signInWithCredential(v);
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop;
      }, onFailed: (e) {
        // ignore: avoid_print
        print("Le code est erroné");
      }, autoRetrieval: (v) {});
    }
    // await DatabaseService(uid: user?.uid).updateUserData(
    //   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSI7GmgeofxR_sr_Tfoh6mETMk8T3a0vysloClcX3c&s',
    //   'Votre nom',
    //   'votreemail@adresse.com',
    //   'Indiquez-nous votre location',
    // );x
  }

  @override
  Widget build(BuildContext context) {
    void goToAuth() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (builder) => const AuthPage()));
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const Text(
                "Authentification",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5ACC80),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              // TextField(
              //   //controller: emailController,
              //   onChanged: (value) {
              //     print(value);
              //     phoneNumber = value;
              //   },
              //   // cursorColor: Colors.white,
              //   textInputAction: TextInputAction.next,
              //   decoration: const InputDecoration(
              //       border: OutlineInputBorder(),
              //       labelText: 'Numéro de téléphone'),
              // ),
              IntlPhoneField(
                initialCountryCode: 'CI',
                onChanged: (value) {
                  // ignore: avoid_print
                  print(value.completeNumber);
                  phoneNumber = value.completeNumber;
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: loading ? null : sendOtpCode,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: const Color(0xFF5ACC80),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )
                        : const Text(
                            "Se connecter",
                            style: TextStyle(fontSize: 20),
                          ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                          text: "Pour l'authentification par mail, ",
                          children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = goToAuth,
                          // ..onTap = widget.onClickedSignIn,
                          text: "cliquez-ici",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const TextSpan(
                          text: ".",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ]))),
              //   Row(
              //   children: [
              //     const Text(
              //       "Pour l'authentification par mail, ",
              //       style: const TextStyle(color: Colors.black, fontSize: 16),
              //     ),
              //     TextButton(
              //       onPressed: () {
              //         Navigator.of(context).push(MaterialPageRoute(
              //             builder: (builder) => const AuthPage()));
              //       },
              //       child: Text(
              //         "Cliquez-ici",
              //         style: const TextStyle(
              //           decoration: TextDecoration.underline,
              //           color: Theme.of(context).colorScheme.primary,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // ),
              const SizedBox(height: 90),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
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
      ),
    );
  }
}

void showLoginAdmin() {
  // if (1 == 1) {
  const SnackBar(
    content: LoginAdmin(),
    backgroundColor: Colors.white,
  );
  // } else {}
}

class LoginAdmin extends StatefulWidget {
  const LoginAdmin({
    super.key,
  });

  @override
  LoginAdminState createState() => LoginAdminState();
}

class LoginAdminState extends State<LoginAdmin> {
  String takeValue = '';
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Utils utilsWidget = Utils();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  bool activeButton = true;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 190.0),
              TextFormField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Email'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value) {
                  takeValue = value;
                  setState(() {});
                },
                validator: (String? value) {
                  if (value != "afrikeclat@gmail.com") {
                    //if (value == null || value.isEmpty) {
                    return 'Etes-vous un admin ?';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 4.0),
              TextFormField(
                controller: passwordController,
                // cursorColor: Colors.white,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      );
}
