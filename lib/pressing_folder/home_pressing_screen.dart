import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espace_kong/home_folder/tarifs.dart';
import 'package:espace_kong/pressing_folder/archives.dart';
import 'package:espace_kong/pressing_folder/demande_page.dart';
import 'package:espace_kong/slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePressing extends StatefulWidget {
  const HomePressing({super.key});

  @override
  HomePressingView createState() => HomePressingView();
}

class HomePressingView extends State<HomePressing> {
  void askOrder() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Utilisateur non connecté.')),
      );
      return;
    }

    final doc =
        await FirebaseFirestore.instance.collection('contacts').doc(uid).get();

    if (!doc.exists || doc.data() == null || doc['phone'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun numéro associé à ce compte.')),
      );
      return;
    }

    final phoneNumber = doc['phone'] as String;
    final now = DateTime.now();
    final monthDoc =
        "${now.year}-${now.month.toString().padLeft(2, '0')}"; // ex: "2025-06"

    // Send to Firestore
    await FirebaseFirestore.instance
        .collection('orders_users')
        .doc(monthDoc)
        .set({
          'phone': phoneNumber,
          'email': FirebaseAuth.instance.currentUser?.email,
          'createdAt': FieldValue.serverTimestamp(),
          'archived': false,
        });

    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => DemandeEnvoyee()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orangeAccent,
        title: const Center(
          // child: Text('Que voulez-vous laver ?')
          child: Text(
            'ePressing de Kong',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Expanded(child: Slidercarrousel())],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 26.0),
                  Text(
                    'Cliquez sur le bouton suivant pour qu\'on vienne cherchez vos habits :',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 37.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: askOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.all(16.0),
                      ),
                      child: const Text(
                        'Venez chercher mes habits',
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  Center(
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Tarifs()),
                            );
                          },
                          child: Text("Voir les tarifs"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Archives(),
                              ),
                            );
                          },
                          child: Text("Archives de commandes"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 29.0),
          ],
        ),
      ),
    );
  }
}

Widget myDialog() {
  return const AlertDialog();
}
