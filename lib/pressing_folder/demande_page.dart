// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espace_kong/home_folder/home.dart';
import 'package:espace_kong/home_folder/navigation_drawer.dart';
import 'package:espace_kong/pressing_folder/details_commandes_screen.dart';
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DemandeEnvoyee extends StatefulWidget {
  const DemandeEnvoyee({super.key});

  @override
  DemandeEnvoyeeView createState() => DemandeEnvoyeeView();
}

class DemandeEnvoyeeView extends State<DemandeEnvoyee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ftkColor,
        title: Center(
          // child: Text('Que voulez-vous laver ?')
          child: Text(
            'Demande envoyée!',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => launchUrl(Uri.parse("tel://0707104044")),
            // Navigator.of(context)
            //     .pushReplacement(MaterialPageRoute(builder: (context) => Shop()));
            icon: const Icon(Icons.call),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 29.0),
            Image.asset(
              'assets/images/validate.png',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: const Text(
                'Votre demande a été envoyée avec succès ! Veuillez patienter, on viendra chercher vos habits en moins de 10 minutes.',
              ),
            ),
            const SizedBox(height: 20.0),
            MaterialButton(
              color: ftkColor,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommandeDetailsScreen(),
                  ),
                );
              },
              child: const Text(
                'Page de commandes',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
