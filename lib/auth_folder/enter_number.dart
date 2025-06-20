import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espace_kong/home_folder/home.dart';
import 'package:espace_kong/pressing_folder/details_commandes_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

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
  String selectedVille = 'Choisissez la ville';
  final List<String> villes = [
    'Choisissez la ville',
    'Kong',
    'Ferkessedougou',
    'Dabakala',
    'Autre',
  ];
  String autreQuartier = '';
  String autreVille = '';
  // ...existing code...
  final TextEditingController autreVilleController = TextEditingController();
  final TextEditingController autreQuartierController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserContact();
  }

  Future<void> fetchUserContact() async {
    if (userEmail == null) return;
    final query =
        await FirebaseFirestore.instance
            .collection('contacts')
            .where('email', isEqualTo: userEmail)
            .limit(1)
            .get();
    if (query.docs.isNotEmpty) {
      final data = query.docs.first.data();
      setState(() {
        phoneNumber = data['phone'] ?? '';
        phoneController.text = phoneNumber.replaceFirst('+225', '');
        selectedVille =
            villes.contains(data['ville']) ? data['ville'] : 'Autre';
        selectedQuartier =
            quartiers.contains(data['quartier']) ? data['quartier'] : 'Autre';
        autreVille = selectedVille == 'Autre' ? data['ville'] ?? '' : '';
        autreQuartier =
            selectedQuartier == 'Autre' ? data['quartier'] ?? '' : '';
        autreVilleController.text = autreVille;
        autreQuartierController.text = autreQuartier;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text(
              "Entrez votre contact :",
              style: TextStyle(
                fontSize: 21,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: IntlPhoneField(
                controller: phoneController,
                initialCountryCode: 'CI',
                initialValue:
                    phoneNumber.isNotEmpty
                        ? phoneNumber.replaceFirst(
                          '+225',
                          '',
                        ) // Remove country code if present
                        : null,
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
            SizedBox(height: 13.0),
            Text(
              "Quel ville ? :",
              style: TextStyle(
                fontSize: 21,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 13.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: DropdownButtonFormField<String>(
                value: selectedVille,
                items:
                    villes
                        .map((q) => DropdownMenuItem(value: q, child: Text(q)))
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedVille = value!;
                    if (selectedVille != 'Autre') {
                      autreVille = '';
                    }
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Villes',
                ),
              ),
            ),
            if (selectedVille == 'Autre')
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: TextField(
                  controller: autreVilleController,
                  onChanged: (value) => autreVille = value,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Précisez la ville',
                  ),
                ),
              ),
            SizedBox(height: 13.0),
            Text(
              "Quel quartier ? :",
              style: TextStyle(
                fontSize: 21,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 13.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: DropdownButtonFormField<String>(
                value: selectedQuartier,
                items:
                    quartiers
                        .map((q) => DropdownMenuItem(value: q, child: Text(q)))
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: TextField(
                  controller: autreQuartierController,
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
                    backgroundColor: ftkColor,
                  ),
                  child: const Text(
                    "Enregistrer",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
            SizedBox(height: 13.0),
            Text(
              "ou",
              style: TextStyle(
                fontSize: 21,
                color: Colors.black,
                //fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => Home()));
              },

              style: ElevatedButton.styleFrom(
                //padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: ftkColor, // Border color
                  width: 2, // Border width
                ),
              ),
              child: Text(
                "Annuler",
                style: TextStyle(fontSize: 16, color: ftkColor),
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
      final villeToSave = selectedVille == 'Autre' ? autreVille : selectedVille;
      await FirebaseFirestore.instance.collection('contacts').doc(uid).set({
        'phone': phoneNumber,
        'email': email,
        'ville': villeToSave,
        'quartier': quartierToSave,
        'createdAt': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Infos enregistrés !')));
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (builder) => Home()));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}
