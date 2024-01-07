// forum.dart

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:neuroparenting/src/theme/theme.dart';
import 'package:get/get.dart';
// import 'package:neuroparenting/src/reusable_func/theme_change.dart';

class ForumPage extends StatefulWidget {
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

  const ForumPage({
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
  ForumPageState createState() => ForumPageState();
}

class ForumPageState extends State<ForumPage> {
  int current = 0;
  bool isDarkMode = Get.isDarkMode;

  @override
  void initState() {
    super.initState();
    current = widget.current;
    isDarkMode = Get.isDarkMode;
  }

  @override
  Widget build(context) {
    return Column(children: [
      Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16.0),
              bottomRight: Radius.circular(16.0),
            ),
            color: Theme.of(context).brightness == Brightness.dark
                ? ThemeClass().darkRounded
                : ThemeClass().lightPrimaryColor),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black
                        : Colors.white,
                    prefixIcon: const Icon(
                      Icons.search,
                    ),
                    hintText: 'Search for discussion...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.lightBlue,
                          width: 2),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add,
                    size: 50,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black
                        : Colors.white),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  width: 400,
                  height: 100,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color.fromARGB(255, 124, 129, 140)
                          : const Color.fromARGB(255, 243, 243, 243)),
                  child: const Center(
                    child: Text("udin"),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  width: 400,
                  height: 100,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color.fromARGB(255, 124, 129, 140)
                          : const Color.fromARGB(255, 243, 243, 243)),
                  child: const Center(
                    child: Text("udin anak mang ujang"),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  width: 400,
                  height: 100,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color.fromARGB(255, 124, 129, 140)
                          : const Color.fromARGB(255, 243, 243, 243)),
                  child: const Center(
                    child: Text("bedul"),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  width: 400,
                  height: 100,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color.fromARGB(255, 124, 129, 140)
                          : const Color.fromARGB(255, 243, 243, 243)),
                  child: const Center(
                    child: Text("bedul"),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  width: 400,
                  height: 100,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color.fromARGB(255, 124, 129, 140)
                          : const Color.fromARGB(255, 243, 243, 243)),
                  child: const Center(
                    child: Text("bedul 1"),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  width: 400,
                  height: 100,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color.fromARGB(255, 124, 129, 140)
                          : const Color.fromARGB(255, 243, 243, 243)),
                  child: const Center(
                    child: Text("bedul 2"),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    ]);
  }
}
