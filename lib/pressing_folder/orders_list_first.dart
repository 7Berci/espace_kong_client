// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espace_kong/home_folder/home.dart';
import 'package:espace_kong/pressing_folder/details_commandes_screen.dart';
import 'package:flutter/material.dart';

class OrdersListFirst extends StatefulWidget {
  const OrdersListFirst({super.key});

  @override
  State<OrdersListFirst> createState() => _OrdersListFirstState();
}

class _OrdersListFirstState extends State<OrdersListFirst> {
  @override
  void initState() {
    // _streamShoppingItems =
    //     DatabaseService(uid: user?.uid).ordersCollection.snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //try {
    return Scaffold(
      appBar: myAppBar('Les articles de la commande :', true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('orders')
                      .where(
                        'email',
                        isEqualTo: userEmail,
                      ) // ou this.email selon le contexte
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Erreur : ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return Text(
                    "Veuillez patienter le temps qu'on actualise les articles de votre commande.",
                  );
                }
                final commandes = snapshot.data!.docs;
                if (commandes.isEmpty) {
                  return Center(
                    child: Text(
                      "Aucun article, veuillez patienter le temps qu'on actualise les articles de votre commande..",
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: commandes.length,
                  itemBuilder: (context, index) {
                    final commande = commandes[index];
                    final data = commande.data() as Map<String, dynamic>;
                    final articles = data['articles'] as List<dynamic>? ?? [];
                    final remises =
                        data['remises'] as Map<String, dynamic>? ?? {};
                    final fraisLivraison = data['fraisLivraison'] ?? 0;
                    final totalSansRemise = data['totalSansRemise'] ?? 0;
                    final totalFinal = data['totalFinal'] ?? 0;

                    return Card(
                      margin: EdgeInsets.all(8),
                      child: ExpansionTile(
                        title: Text('Commande de ${data['email']}'),
                        subtitle: Text('Total à payer : $totalFinal FCFA'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Détails des articles :',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                if (articles.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Text(
                                      "Aucun article dans cette commande, veuillez patienter le temps qu'on enregistre vos articles.",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                                else
                                  ...articles.map(
                                    (article) => ListTile(
                                      title: Text(
                                        '${article["Nom de l'article"]} (${article['Type']})',
                                      ),
                                      subtitle: Text(
                                        'Quantité : ${article['Quantité commandée']}',
                                      ),
                                      trailing: Text(
                                        '${article['Coût unitaire']} FCFA',
                                      ),
                                    ),
                                  ),
                                Divider(),
                                Text(
                                  'Frais de livraison : $fraisLivraison FCFA',
                                ),
                                Text(
                                  'Coût total des articles : $totalSansRemise FCFA',
                                ),
                                Text(
                                  'Remise 10% : ${remises['ten'] ?? 0} FCFA',
                                ),
                                Text(
                                  'Remise 20% : ${remises['twenty'] ?? 0} FCFA',
                                ),
                                Text(
                                  'Remise manuelle : ${remises['manuelle'] ?? 0} FCFA',
                                ),
                                Divider(),
                                Text(
                                  'Total à payer : $totalFinal FCFA',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16.0),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
