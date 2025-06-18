import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:espace_kong/culture_folder/article_screen.dart';
import 'package:espace_kong/culture_folder/articles_model_list.dart';
import 'package:flutter/material.dart';

class HomeCulture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Culture & Blog')),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('articles')
                .orderBy('createdAt', descending: false)
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
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(article.title),
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
