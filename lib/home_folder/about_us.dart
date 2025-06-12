import 'videoplayer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher.dart';



class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    void callUs() {
      launchUrl(Uri.parse("tel://0707104044"));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('A propos de nous'),
      ),
      body: ListView(
        children: [
          SamplePlayer(),
           Padding(
        padding: const EdgeInsets.all(12.0),
        child: RichText(
            text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 18),
          
          children: [
            TextSpan(
              recognizer: TapGestureRecognizer()..onTap = callUs,
              text: "nous contactez",
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const TextSpan(
              text: " directement.",
              style: TextStyle(color: Colors.black, fontSize: 18
                  //decoration: TextDecoration.underline,
                  //color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        )),
      ),
        ],
      ),
    );
  }
}
