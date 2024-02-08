// homebody.dart

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:neuroparenting/src/pages/article/article.dart';
import 'package:neuroparenting/src/theme/theme.dart';
import 'package:neuroparenting/src/pages/under_construction/under_construction.dart';
import 'package:neuroparenting/src/pages/chatbot/chatbot.dart';
import 'package:neuroparenting/src/pages/donate/donate.dart';
import 'package:neuroparenting/src/pages/games/pages/game_page.dart';

class HomePageBody extends StatefulWidget {
  final double height;
  final double width;
  final bool isDarkMode;
  final List<String> buttonTitles;
  final List<IconData> buttonIcons;
  final List<String> imgList;
  final List<String> urlList;
  final CarouselController controller;
  final Function launchUrl;
  final int current;

  const HomePageBody({
    super.key,
    required this.height,
    required this.width,
    required this.isDarkMode,
    required this.buttonTitles,
    required this.buttonIcons,
    required this.imgList,
    required this.urlList,
    required this.controller,
    required this.launchUrl,
    required this.current,
  });

  @override
  HomePageBodyState createState() => HomePageBodyState();
}

class HomePageBodyState extends State<HomePageBody> {
  int current = 0;
  bool isDarkMode = Get.isDarkMode;

  @override
  void initState() {
    super.initState();
    current = widget.current;
    isDarkMode = Get.isDarkMode;
    EasyLoading.dismiss();
  }

  @override
  Widget build(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: widget.width,
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10, // Add some space horizontally
                mainAxisSpacing: 10,
                crossAxisCount: 4,
                children: List.generate(widget.buttonTitles.length, (index) {
                  return _buildFeatureButton(widget.buttonIcons[index],
                      widget.buttonTitles[index], context);
                }),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '   Campaign',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            children: [
              CarouselSlider.builder(
                itemCount: widget.imgList.length,
                carouselController: widget.controller,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) =>
                        GestureDetector(
                  onTap: () async => await widget
                      .launchUrl(Uri.parse(widget.urlList[itemIndex])),
                  child: FadeInImage.assetNetwork(
                    image: widget.imgList[itemIndex],
                    fit: BoxFit.cover,
                    placeholder: 'assets/images/placeholder_loading.gif',
                  ),
                ),
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      current = index;
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.imgList.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => widget.controller.animateToPage(entry.key),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withOpacity(current == entry.key ? 0.9 : 0.4),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          SizedBox(height: widget.height * 0.05)
        ],
      ),
    );
  }
}

Widget _buildFeatureButton(IconData icon, String title, BuildContext context) {
  bool isDarkMode = HomePageBodyState().isDarkMode;
  double deviceWidth = MediaQuery.of(context).size.width;
  return SingleChildScrollView(
    child: Column(
      children: [
        Card(
          color: isDarkMode
              ? ThemeClass().darkRounded
              : ThemeClass().lightPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16), // This makes the card rounded
          ),
          child: InkWell(
            onTap: () {
              if (title == 'Articles') {
                // Create a dummy ArticleOverview instance
                ArticleOverview articleOverview = ArticleOverview(
                  id: '1',
                  title: 'Artikel Autisme',
                  description: 'Dummy Description',
                  imageURL:
                      'https://www.mendelian.co/uploads/190813/autism-150-rare-diseases.jpg',
                );
                // Navigate to ArticleContentPage with the dummy ArticleOverview instance
                Get.to(() => ArticleContentPage(articleOverview));
              } else if (title == 'ChatBot') {
                Get.to(() => const ChatBotPage());
              } else if (title == 'Donate') {
                Get.to(() => const DonatePage());
              } else if (title == 'Games') {
                Get.to(() => const GamePage());
              } else {
                Get.to(() => const UnderConstructionPage());
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                size: deviceWidth * 0.1,
                color: isDarkMode ? Colors.black : Colors.white,
              ), // Adjust the size as needed
            ),
          ),
        ),
        Text(title),
      ],
    ),
  );
}
