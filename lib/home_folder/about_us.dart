import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espace_kong/home_folder/home.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String? phone;

  @override
  void initState() {
    super.initState();
    fetchPhone();
  }

  Future<void> fetchPhone() async {
    // Suppose que tu as un seul document dans la collection 'ftkcontact'
    final snapshot =
        await FirebaseFirestore.instance.collection('ftk_files').limit(1).get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        phone = snapshot.docs.first['phone'];
      });
    }
  }

  void callUs() {
    if (phone != null) {
      launchUrl(Uri.parse("tel://$phone"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('A propos de nous', true),
      body: ListView(
        children: [
          //SamplePlayer(),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Notre entreprise :",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: const Text(
              "Espace Kong est une entreprise locale spécialisée dans le pressing et les services de blanchisserie. "
              "Notre mission est de faciliter la vie de nos clients en leur offrant un service rapide, fiable et de qualité, "
              "adapté à leurs besoins quotidiens. Nous mettons un point d'honneur à la satisfaction de notre clientèle, "
              "en proposant des solutions innovantes et un accompagnement personnalisé. Faites confiance à notre équipe passionnée pour prendre soin de vos vêtements !",
              style: TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: phone == null ? null : callUs,
            icon: const Icon(Icons.phone),
            label: Text(phone ?? "Chargement..."),
          ),
        ],
      ),
    );
  }
}
