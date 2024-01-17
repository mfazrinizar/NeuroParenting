// Dummy, not yet implemented

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
        imageURL: 'https://via.placeholder.com/150',
      ),
    );
  }
}

class ArticleContent {
  final String overview;
  final String howToAddress;

  ArticleContent({
    required this.overview,
    required this.howToAddress,
  });

  static Future<ArticleContent> getDataFromFirestore(String id) async {
    // Dummy data, replace this with your actual data fetching logic
    return ArticleContent(
      overview: 'Overview content for article $id',
      howToAddress: 'How to address content for article $id',
    );
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

class _ArticleContentPageState extends State<ArticleContentPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  ArticleContent? articleContent;
  bool isDarkMode = Get.isDarkMode;
  @override
  void initState() {
    super.initState();
    isDarkMode = Get.isDarkMode;
    tabController = TabController(length: 2, vsync: this);
    loadArticleContent();
  }

  void loadArticleContent() async {
    ArticleContent data =
        await ArticleContent.getDataFromFirestore(widget.articleOverview.id);
    setState(() {
      articleContent = data;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
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
        actions: [
          LanguageSwitcher(
            onPressed: localizationChange,
            textColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
          ),
          ThemeSwitcher(onPressed: () async {
            themeChange();
            setState(() {
              isDarkMode = !isDarkMode;
            });
          }),
          Icon(Icons.notifications,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white),
          Icon(Icons.person,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 300,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(
                fit: StackFit.expand,
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          widget.articleOverview.title,
                          style: GoogleFonts.nunito(
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 130,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        body: Column(
          children: [
            TabBar(
              labelColor: Colors.blue,
              indicatorColor: Colors.blue,
              unselectedLabelColor: const Color.fromARGB(255, 184, 171, 171),
              tabs: [
                Tab(
                  child: Text(
                    "Overview",
                    style: GoogleFonts.nunito(fontWeight: FontWeight.w500),
                  ),
                ),
                Tab(
                  child: Text(
                    "Details",
                    style: GoogleFonts.nunito(fontWeight: FontWeight.w500),
                  ),
                )
              ],
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      child: articleContent == null
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : MarkdownViewer(articleContent!.overview),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      child: articleContent == null
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : MarkdownViewer(articleContent!.howToAddress),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleDictionaryPage extends StatefulWidget {
  const ArticleDictionaryPage({Key? key}) : super(key: key);

  @override
  State<ArticleDictionaryPage> createState() => _ArticleDictionaryPageState();
}

class _ArticleDictionaryPageState extends State<ArticleDictionaryPage> {
  List<ArticleOverview>? articleOverviews;

  @override
  void initState() {
    super.initState();
    loadArticleOverviews();
  }

  void loadArticleOverviews() async {
    List<ArticleOverview> data = await ArticleOverview.getAllFromFirestore();
    setState(() {
      articleOverviews = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        showExitPopup();
      },
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            toolbarHeight: 100,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Artikel',
                  style: GoogleFonts.nunito(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Material(
                  borderRadius: BorderRadius.circular(50),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: InkWell(
                    onTap: () {
                      if (articleOverviews != null) {
                        showSearch(
                          context: context,
                          delegate: CustomSearchDelegate(articleOverviews!),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Cari Artikel',
                              style: GoogleFonts.nunito(fontSize: 15)),
                          const Icon(Icons.search),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: articleOverviews == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: articleOverviews!.length,
                      itemBuilder: (context, index) {
                        var articleOverview = articleOverviews![index];
                        return ArticleListItem(articleOverview);
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Keluar Aplikasi'),
            content: const Text('Kamu ingin keluar aplikasi?'),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  textStyle: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Tidak'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  textStyle: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Ya'),
              ),
            ],
          ),
        ) ??
        false;
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
    return ListTile(
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
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return ArticleContentPage(articleOverview);
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )),
                child: child,
              );
            },
          ),
        );
      },
    );
  }
}
