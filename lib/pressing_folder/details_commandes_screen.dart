import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espace_kong/home_folder/home.dart';
import 'package:espace_kong/pressing_folder/changer_statut.dart';
import 'package:espace_kong/pressing_folder/orders_list_first.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

final user = FirebaseAuth.instance.currentUser;
String? get userEmail => user?.email;

class CommandeDetailsScreen extends StatelessWidget {
  const CommandeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('Détails de la commande', true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 29.0),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('orders_users')
                      .where('email', isEqualTo: userEmail)
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  // If Firestore throws an index error, it will be in snapshot.error
                  final errorMsg = snapshot.error.toString();
                  if (errorMsg.contains('failed-precondition') &&
                      errorMsg.contains('requires an index')) {
                    // Extract the link from the error message
                    final uriRegExp = RegExp(
                      r'(https:\/\/console\.firebase\.google\.com\/[^\s]+)',
                    );
                    final match = uriRegExp.firstMatch(errorMsg);
                    final url = match?.group(0);
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Firestore index required for this query.',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (url != null)
                            TextButton(
                              onPressed: () async {
                                // Open the link to create the index
                                await launchUrl(Uri.parse(url));
                              },
                              child: const Text('Create Firestore Index'),
                            ),
                          const SizedBox(height: 16),
                          Text(errorMsg, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    );
                  }
                  // Other errors
                  return Center(child: Text('Erreur : ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                      'Pas de nouvelle commande',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 8.0,
                      ),
                      child: Text(
                        'Nouvelle(s) commande(s) :',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Les données du tableau se mettrons à jour au fur et à mesure de l'évolution du traitement :",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('#')),
                          DataColumn(label: Text('Date')),
                          DataColumn(label: Text('Montant')),
                          DataColumn(label: Text('Articles')),
                          DataColumn(label: Text('Statut')),
                        ],
                        rows: List.generate(docs.length, (index) {
                          final data =
                              docs[index].data() as Map<String, dynamic>;
                          final createdAt =
                              data['createdAt'] is Timestamp
                                  ? (data['createdAt'] as Timestamp).toDate()
                                  : DateTime.now();
                          //final userEmail = data['email'];

                          return DataRow(
                            cells: [
                              DataCell(Text('${index + 1}')),
                              DataCell(
                                Text(
                                  DateFormat(
                                    'dd/MM/yyyy HH:mm',
                                  ).format(createdAt),
                                ),
                              ),
                              DataCell(
                                StreamBuilder<QuerySnapshot>(
                                  stream:
                                      FirebaseFirestore.instance
                                          .collection('orders')
                                          .where(
                                            'email',
                                            isEqualTo: userEmail,
                                          ) // adapte le champ si besoin
                                          .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }
                                    if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
                                      return Text('--');
                                    }
                                    // Exemple : somme des totaux pour cet utilisateur
                                    double total = 0;
                                    for (var doc in snapshot.data!.docs) {
                                      total +=
                                          double.tryParse(
                                            doc['totalFinal']
                                                .toString()
                                                .replaceAll(' FCFA', ''),
                                          ) ??
                                          0;
                                    }
                                    return Text('$total FCFA');
                                  },
                                ),
                              ),
                              DataCell(
                                StreamBuilder<QuerySnapshot>(
                                  stream:
                                      FirebaseFirestore.instance
                                          .collection('orders')
                                          .where(
                                            'email',
                                            isEqualTo: userEmail,
                                          ) // adapte le champ si besoin
                                          .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }
                                    if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
                                      return TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder:
                                                  (builder) =>
                                                      OrdersListFirst(),
                                            ),
                                          );
                                        },
                                        child: Text('--'),
                                      );
                                    }
                                    final docs = snapshot.data!.docs;
                                    int totalQuantite = 0;
                                    for (var doc in docs) {
                                      final data =
                                          doc.data() as Map<String, dynamic>;
                                      final articles =
                                          data['articles'] as List<dynamic>? ??
                                          [];

                                      for (var article in articles) {
                                        totalQuantite +=
                                            int.tryParse(
                                              article['Quantité commandée']
                                                  .toString(),
                                            ) ??
                                            0;
                                      }
                                    }
                                    return TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (builder) => OrdersListFirst(),
                                          ),
                                        );
                                      },
                                      child: Text('$totalQuantite'),
                                    );
                                  },
                                ),
                              ),
                              DataCell(
                                StreamBuilder<DocumentSnapshot>(
                                  stream:
                                      FirebaseFirestore.instance
                                          .collection('status')
                                          .doc(
                                            userEmail,
                                          ) // ou adapte selon ton id de commande
                                          .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }
                                    if (!snapshot.hasData ||
                                        !snapshot.data!.exists) {
                                      return TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder:
                                                  (builder) => StatusMenu(
                                                    email: userEmail,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: Text('Aucun statut'),
                                      );
                                    }
                                    final data =
                                        snapshot.data!.data()
                                            as Map<String, dynamic>;
                                    final statuts =
                                        data['statuts']
                                            as Map<String, dynamic>?;

                                    if (statuts == null || statuts.isEmpty) {
                                      return TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder:
                                                  (builder) => StatusMenu(
                                                    email: userEmail,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: Text('Aucun statut'),
                                      );
                                    }

                                    // On récupère la liste des statuts activés (true)
                                    final activeStatuts =
                                        statuts.entries
                                            .where((e) => e.value == true)
                                            .map((e) => e.key)
                                            .toList();

                                    if (activeStatuts.isEmpty) {
                                      return TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder:
                                                  (builder) => StatusMenu(
                                                    email: userEmail,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: Text('Aucun statut'),
                                      );
                                    }

                                    // On prend le dernier statut activé (le plus à droite dans la liste)
                                    final lastActive = activeStatuts.last;

                                    return TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (builder) => StatusMenu(
                                                  email: userEmail,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Text(lastActive),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
