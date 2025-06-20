import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espace_kong/home_folder/home.dart';
import 'package:flutter/material.dart';

class StatusMenu extends StatefulWidget {
  final email; // Pass the order/document ID to update the right document

  const StatusMenu({super.key, required this.email});

  @override
  State<StatusMenu> createState() => _StatusMenuState();
}

class _StatusMenuState extends State<StatusMenu> {
  // List of status titles
  final List<String> statusTitles = [
    'Commande passée!',
    'Habits récupérés!',
    'Facture envoyée/reçue!',
    'Habits en cours de lavage!',
    'Lavage terminé!',
    'Livraison retour en cours!',
    'Habits livrés!',
    'Terminé!',
  ];

  // Local status state (all false by default)
  late List<bool> statusStates;

  @override
  void initState() {
    super.initState();
    statusStates = List.generate(statusTitles.length, (_) => false);

    // Récupère les statuts depuis Firestore
    FirebaseFirestore.instance
        .collection('status')
        .doc(widget.email)
        .get()
        .then((doc) {
          if (doc.exists) {
            final data = doc.data();
            final statuts = data?['statuts'] as Map<String, dynamic>?;

            if (statuts != null) {
              setState(() {
                for (int i = 0; i < statusTitles.length; i++) {
                  statusStates[i] = statuts[statusTitles[i]] == true;
                }
              });
            }
          }
        });
  }

  void updateStatus(int index, bool newStatus) async {
    setState(() {
      statusStates[index] = newStatus;
    });

    // Update the status in Firestore (adapt the structure as needed)
    await FirebaseFirestore.instance.collection('status').doc(widget.email).set(
      {
        'statuts': {statusTitles[index]: newStatus},
      },
      SetOptions(merge: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('Statuts de la commande', true),
      body: Padding(
        padding: const EdgeInsets.all(12.5),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: statusTitles.length,
          separatorBuilder: (_, __) => Divider(),
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(statusTitles[index]),
                Icon(
                  statusStates[index] ? Icons.toggle_on : Icons.toggle_off,
                  color: statusStates[index] ? Colors.green : Colors.grey,
                  size: 32,
                ),
                // onPressed: () {
                //   updateStatus(index, !statusStates[index]);
                // },
              ],
            );
          },
        ),
      ),
    );
  }
}
