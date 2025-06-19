import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espace_kong/culture_folder/article_screen.dart';
import 'package:espace_kong/culture_folder/articles_model_list.dart';
import 'package:espace_kong/home_folder/home.dart';
import 'package:flutter/material.dart';

class HomeCulture extends StatelessWidget {
  const HomeCulture({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Column(
          children: [
            // Black border (2 pixels high)
            Container(height: 2, color: Colors.black),
            // The actual AppBar
            Expanded(
              child: AppBar(
                automaticallyImplyLeading: false,
                title: const Center(
                  child: Text(
                    'Culture & Blog',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                backgroundColor: ftkColor,
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('articles')
                .orderBy('id', descending: false)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucun article trouvé.'));
          }
          final articles =
              snapshot.data!.docs
                  .map(
                    (doc) => Article.fromFirestore(
                      doc.data() as Map<String, dynamic>,
                    ),
                  )
                  .toList();

          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Card(
                child: ListTile(
                  leading: Image.network(
                    article.thumbnailUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            Icon(Icons.image_not_supported),
                  ),
                  title: Text(article.title),
                  trailing: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticlePage(article: article),
                        ),
                      );
                    },
                    child: Text('Voir'),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticlePage(article: article),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
