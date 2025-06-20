import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espace_kong/home_folder/home.dart';
import 'package:flutter/material.dart';

class Tarifs extends StatefulWidget {
  const Tarifs({super.key});

  @override
  TarifsView createState() => TarifsView();
}

class TarifsView extends State<Tarifs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('Tarifs', true),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('products')
                .orderBy('id', descending: false)
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final products =
              snapshot.data!.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();

          // Regroupement par Type puis par Cat
          final Map<String, Map<String, List<Map<String, dynamic>>>> grouped =
              {};

          for (var product in products) {
            final type = product['type'] ?? 'Autre';
            final cat = product['cat'] ?? 'Autre';

            grouped[type] ??= {};
            grouped[type]![cat] ??= [];
            grouped[type]![cat]!.add(product);
          }

          return ListView(
            children:
                grouped.entries.map((typeEntry) {
                  final type = typeEntry.key;
                  final cats = typeEntry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 12.0,
                        ),
                        child: Text(
                          type,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent,
                          ),
                        ),
                      ),
                      ...cats.entries.map((catEntry) {
                        final cat = catEntry.key;
                        final productsList = catEntry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 20.0,
                              ),
                              child: Text(
                                cat,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            ...productsList.map((product) {
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                child: ListTile(
                                  leading:
                                      product['photo'] != null
                                          ? Image.network(
                                            product['photo'],
                                            width: 56,
                                            height: 56,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(
                                                      Icons.image_not_supported,
                                                    ),
                                          )
                                          : const Icon(Icons.image),
                                  title: Text(product['nameproduct'] ?? ''),
                                  subtitle: Text(
                                    'Catégorie : ${product['cat'] ?? ''}',
                                  ),
                                  trailing: Text(
                                    '${product['price'] ?? ''} FCFA',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        );
                      }),
                    ],
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}
