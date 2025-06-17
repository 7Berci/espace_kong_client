import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Ajoute cet import si manquant
import 'package:flutter/material.dart';

class Archives extends StatelessWidget {
  const Archives({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    String? email = user?.email;

    return Scaffold(
      appBar: AppBar(title: Text('Produits archivés')),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('orders_archive')
                .where('email', isEqualTo: email)
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final commandes = snapshot.data!.docs;

          List<Widget> allTiles = [];
          for (var commande in commandes) {
            final data = commande.data() as Map<String, dynamic>;
            final ville = data['ville'] ?? '';
            final quartier = data['quartier'] ?? '';
            final articles = data['articles'] as List<dynamic>? ?? [];

            for (var article in articles) {
              allTiles.add(
                ListTile(
                  title: Text(article["Nom de l'article"] ?? ''),
                  subtitle: Text(
                    'Quantité : ${article['Quantité commandée']} | Type : ${article['Type']}',
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${article['Coût unitaire']} FCFA'),
                      Text('Ville : $ville'),
                      Text('Quartier : $quartier'),
                    ],
                  ),
                ),
              );
              allTiles.add(Divider());
            }
          }

          if (allTiles.isEmpty) {
            return Center(child: Text('Aucun produit archivé.'));
          }

          return ListView(children: allTiles);
        },
      ),
    );
  }
}
