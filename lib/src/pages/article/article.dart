import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown_viewer/markdown_viewer.dart';
import 'package:neuroparenting/src/homepage.dart';
import 'package:neuroparenting/src/reusable_comp/language_changer.dart';
import 'package:neuroparenting/src/reusable_comp/theme_changer.dart';
import 'package:neuroparenting/src/reusable_func/localization_change.dart';
import 'package:neuroparenting/src/reusable_func/theme_change.dart';
import 'package:neuroparenting/src/theme/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleOverview {
  final String id;
  final String title;
  final String description;
  final String imageURL;

  ArticleOverview({
    required this.id,
    required this.title,
    required this.description,
    required this.imageURL,
  });

  static Future<List<ArticleOverview>> getAllFromFirestore() async {
    return List.generate(
      5,
      (index) => ArticleOverview(
        id: index.toString(),
        title: 'Article $index',
        description: 'Description of Article $index',
        imageURL:
            'https://www.mendelian.co/uploads/190813/autism-150-rare-diseases.jpg',
      ),
    );
  }
}

class ArticleContent {
  final String body;

  ArticleContent({
    required this.body,
  });

  static Future<ArticleContent> getDataFromFirestore(String id) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('articles').doc(id).get();
      if (snapshot.exists) {
        final Map<String, dynamic> data = snapshot.data()!;
        final String body = data['body'] ?? '';
        return ArticleContent(body: body);
      } else {
        throw Exception('Document with ID $id does not exist');
      }
    } catch (e) {
      throw Exception('Failed to fetch data from Firestore: $e');
    }
  }
}

class ArticleContentPage extends StatefulWidget {
  final ArticleOverview articleOverview;

  const ArticleContentPage(
    this.articleOverview, {
    Key? key,
  }) : super(key: key);

  @override
  State<ArticleContentPage> createState() => _ArticleContentPageState();
}

class _ArticleContentPageState extends State<ArticleContentPage> {
  ArticleContent? articleContent;
  bool isDarkMode = Get.isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = Get.isDarkMode;
    loadArticleContent();
  }

  void loadArticleContent() async {
    try {
      ArticleContent data =
          await ArticleContent.getDataFromFirestore(widget.articleOverview.id);
      setState(() {
        articleContent = data;
      });
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? ThemeClass().darkRounded
            : ThemeClass().lightPrimaryColor,
        elevation: 0,
        title: Text(
          'Article',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
          ),
        ),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Get.offAll(() => const HomePage());
            }),
        // Other app bar actions...
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Image.network(
                widget.articleOverview.imageURL,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Text(
                  widget.articleOverview.title,
                  style: GoogleFonts.nunito(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: articleContent == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Text(
                    articleContent!.body,
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }
}

class ArticleDictionaryPage extends StatelessWidget {
  const ArticleDictionaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Dictionary'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('articles').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching data'),
            );
          }
          final List<ArticleOverview> articleOverviews = snapshot.data!.docs
              .map((doc) => ArticleOverview(
                    id: doc.id,
                    title: doc['title'],
                    description: doc['body'],
                    imageURL: doc['imageUrl'],
                  ))
              .toList();
          return ListView.builder(
            itemCount: articleOverviews.length,
            itemBuilder: (context, index) {
              return ArticleListItem(articleOverviews[index]);
            },
          );
        },
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  final List<ArticleOverview> articleOverviews;

  CustomSearchDelegate(this.articleOverviews);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<ArticleOverview> matchQuery = [];
    for (ArticleOverview articleOverview in articleOverviews) {
      if (articleOverview.title.toLowerCase().contains(query.toLowerCase()) ||
          articleOverview.description
              .toLowerCase()
              .contains(query.toLowerCase())) {
        matchQuery.add(articleOverview);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ArticleListItem(result);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}

class ArticleListItem extends StatelessWidget {
  final ArticleOverview articleOverview;

  const ArticleListItem(
    this.articleOverview, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleContentPage(articleOverview),
          ),
        );
      },
      child: ListTile(
        leading: Image.network(
          articleOverview.imageURL,
          fit: BoxFit.cover,
          height: 50,
          width: 80,
          alignment: Alignment.topCenter,
        ),
        title: Text(
          articleOverview.title,
          style: GoogleFonts.nunito(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          articleOverview.description,
          style: GoogleFonts.nunito(fontSize: 15),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        trailing: const Icon(Icons.arrow_right),
      ),
    );
  }
}
