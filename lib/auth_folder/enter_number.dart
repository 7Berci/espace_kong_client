import 'package:espace_kong/home_folder/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EnterNumber extends StatefulWidget {
  const EnterNumber({super.key});

  @override
  EnterNumberView createState() => EnterNumberView();
}

class EnterNumberView extends State<EnterNumber> {
  String phoneNumber = '';
  bool isLoading = false; 
  String selectedQuartier = 'Choisissez le quartier';
  final List<String> quartiers = [
    'Choisissez le quartier',
    'Résidentiel',
    'Antenne',
    'Barola',
    'Somasso',
    'Somagana',
    'Sakharang',
    'Kerehou',
    'Pharmacie',
    'Autre',
  ];
  String autreQuartier = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text("Entrez votre contact :",
                style: TextStyle(
                  fontSize: 21,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: IntlPhoneField(
                  initialCountryCode: 'CI',
                  showDropdownIcon: false,
                  onChanged: (value) {
                    // ignore: avoid_print
                    print(value.completeNumber);
                    phoneNumber = value.completeNumber;
                  },
                  countries: [countries.firstWhere((c) => c.code == 'CI')],
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),
            ),
            Text("Quel quartier ? :",
                style: TextStyle(
                  fontSize: 21,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),),
            SizedBox(height:13.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: DropdownButtonFormField<String>(
                value: selectedQuartier,
                items: quartiers
                    .map((q) => DropdownMenuItem(
                          value: q,
                          child: Text(q),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedQuartier = value!;
                    if (selectedQuartier != 'Autre') {
                      autreQuartier = '';
                    }
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Quartier',
                ),
              ),
            ),
            if (selectedQuartier == 'Autre')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  onChanged: (value) => autreQuartier = value,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Précisez le quartier',
                  ),
                ),
              ),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: sendNumber,
                    style: ElevatedButton.styleFrom(
                      //padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: const Color(0xFF5ACC80),
                    ),
                    child: const Text(
                            "Enregistrer",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white),
                          ),
                  ),
          ],
        ),
      ),
    );
  }

  String? email = FirebaseAuth.instance.currentUser?.email;
  Future<void> sendNumber() async {
      if (phoneNumber.isEmpty) return;
  final uid = FirebaseAuth.instance.currentUser?.uid;
  setState(() => isLoading = true);
  try {
      final quartierToSave =
          selectedQuartier == 'Autre' ? autreQuartier : selectedQuartier;
      await FirebaseFirestore.instance.collection('contacts').doc(uid).set({
        'phone': phoneNumber,
        'email': email,
        'quartier': quartierToSave,
        'createdAt': FieldValue.serverTimestamp(),
      });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Numéro enregistré !')),
    );
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (builder) => Home()));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur : $e')),
    );
  } finally {
      if (mounted) setState(() => isLoading = false);
    }
    }
}