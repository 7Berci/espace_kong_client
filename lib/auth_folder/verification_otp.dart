import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'function.dart';
import '../home_folder/home.dart';

class VerificationOtp extends StatefulWidget {
  const VerificationOtp(
      {super.key, required this.verificationId, required this.phoneNumber});
  final String verificationId;
  final String phoneNumber;

  @override
  State<VerificationOtp> createState() => _VerificationOtpState();
}

class _VerificationOtpState extends State<VerificationOtp> {
  String smsCode = "";
  bool loading = false;
  bool resend = false;
  int count = 20;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    decompte();
  }

  late Timer timer;

  void decompte() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (count < 1) {
        timer.cancel();
        count = 40;
        resend = true;
        setState(() {});
        return;
      }
      count--;
      setState(() {});
    });
  }

  void onResendSmsCode() {
    resend = false;
    setState(() {});
    authWithPhoneNumber(widget.phoneNumber, onCodeSend: (verificationId, v) {
      loading = false;
      decompte();
      setState(() {});
    }, onAutoVerify: (v) async {
      await _auth.signInWithCredential(v);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop;
    }, onFailed: (e) {
      // ignore: avoid_print
      print("Le code est erroné");
    }, autoRetrieval: (v) {});
  }

  void onVerifySmsCode() async {
    loading = true;
    setState(() {});
    await validateOtp(smsCode, widget.verificationId);
    loading = true; //he said false but put true
    // return await DatabaseService(uid: user?.uid).updateUserData(
    //   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSI7GmgeofxR_sr_Tfoh6mETMk8T3a0vysloClcX3c&s',
    //   'Votre nom',
    //   'votreemail@adresse.com',
    //   'Indiquez-nous votre location',
    // );
    setState(() {});
    // ignore: use_build_context_synchronously
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (builder) => const Home()));
    //Navigator.of(context).pop();
    // ignore: avoid_print
    print("Vérification effectuée avec succès !");
    // await DatabaseService(uid: user?.uid).updateUserData(
    //   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSI7GmgeofxR_sr_Tfoh6mETMk8T3a0vysloClcX3c&s',
    //   'Votre nom',
    //   'votreemail@adresse.com',
    //   'Indiquez-nous votre location',
    //   false,
    // );
    return
        // await DatabaseService(uid: user?.uid).updateUserData(
        //     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSI7GmgeofxR_sr_Tfoh6mETMk8T3a0vysloClcX3c&s',
        //     'Votre nom',
        //     'votreemail@adresse.com',
        //     'Indiquez-nous votre location',
        //   )
        ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return false; //true if we don't put the function on, and then we can
          // put a dialog box to ask them if they are sure.
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const Text(
                  "Vérification",
                  style: TextStyle(
                    fontSize: 30,
                    color: Color(0xFF5ACC80),
                  ),
                ),
                const Text(
                  "Vérifiez vos messages pour valider",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF000000),
                  ),
                ),
                const SizedBox(height: 20),
                Pinput(
                    length: 6,
                    onChanged: (value) {
                      smsCode = value;
                      setState(() {});
                    }),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: !resend ? null : onResendSmsCode,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF5ACC80),
                    ),
                    child: Text(
                      !resend
                          ? "00:${count.toString().padLeft(2, "0")}"
                          : "Renvoyer le code",
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: smsCode.length < 6 || loading
                          ? null
                          : onVerifySmsCode,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        foregroundColor: const Color(0xFF5ACC80),
                      ),
                      child: loading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                          : const Text(
                              "Vérifier",
                              style: TextStyle(fontSize: 20),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
