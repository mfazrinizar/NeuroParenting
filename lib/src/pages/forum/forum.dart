// forum.dart

import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
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

class Discussion {
  final String userAvatarUrl;
  final String userName;
  final String userType;
  final String title;
  final List<String> tags;
  final String datePosted;
  int likes;
  final int comments;

  Discussion({
    required this.userAvatarUrl,
    required this.userName,
    required this.userType,
    required this.title,
    required this.tags,
    required this.datePosted,
    required this.likes,
    required this.comments,
  });
}

class ForumPageState extends State<ForumPage> {
  final titlePostController = TextEditingController();
  final descriptionPostController = TextEditingController();
  final tagPostController = TextEditingController();
  final themeClass = ThemeClass();
  List<bool> hasLiked = [];
  int current = 0;
  bool isDarkMode = Get.isDarkMode;
  Map<String, bool> tagCheckboxes = {
    'DCD': false,
    'Dyslexia': false,
    'ADHD': false,
    'Others': false,
  };
  List<Discussion> discussions = List<Discussion>.generate(
    5,
    (index) => Discussion(
      userAvatarUrl:
          'https://via.placeholder.com/45${index + 1}.png', // replace with a dummy URL
      userName: 'User ${index + 1}', // replace with a dummy name
      userType: index % 2 == 0
          ? 'Parent'
          : 'Psychologist', // replace with a dummy user type
      title: 'Discussion Title ${index + 1}', // replace with a dummy title
      tags: ['DCD', 'OCD'], // replace with dummy tags
      datePosted: '2022-01-0${index + 1}',
      likes: 1 + index,
      comments: 2 + index + 2, // replace with a dummy date
    ),
  );

  @override
  void initState() {
    super.initState();
    current = widget.current;
    isDarkMode = Get.isDarkMode;
    hasLiked = List<bool>.filled(discussions.length, false);
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
                ? themeClass.darkRounded
                : themeClass.lightPrimaryColor),
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
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        scrollable: true,
                        title: const Text('Post Discussion'),
                        content: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: titlePostController,
                                    decoration: const InputDecoration(
                                      labelText: 'Title',
                                    ),
                                  ),
                                  TextField(
                                    controller: descriptionPostController,
                                    decoration: const InputDecoration(
                                      labelText: 'Description',
                                    ),
                                    maxLines: 3,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text('Topic/tags:'),
                                  ...tagCheckboxes.entries.map(
                                    (entry) {
                                      return CheckboxListTile(
                                        title: Text(entry.key),
                                        value: entry.value,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            tagCheckboxes[entry.key] = value!;
                                          });
                                        },
                                      );
                                    },
                                  ).toList(),
                                  ElevatedButton(
                                    onPressed: () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: [
                                          'jpg',
                                          'jpeg',
                                          'png'
                                        ],
                                      );

                                      if (result != null) {
                                      } else {}
                                    },
                                    child: const Text('Choose Photo'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Post Discussion'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
      Expanded(
        child: ListView.builder(
          itemCount: discussions.length,
          itemBuilder: (context, index) {
            return Card(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color.fromARGB(255, 124, 129, 140)
                  : const Color.fromARGB(255, 243, 243, 243),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: FadeInImage.assetNetwork(
                            image: discussions[index].userAvatarUrl,
                            placeholder:
                                'assets/images/placeholder_loading.gif',
                            width: 50, // 2x radius
                            height: 50, // 2x radius
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: widget.width * 0.025),
                        Text(discussions[index].userName,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Chip(label: Text(discussions[index].userType)),
                      ],
                    ),
                    Text(discussions[index].title),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Wrap(
                        spacing: 10,
                        children: discussions[index]
                            .tags
                            .map((tag) => Text('#$tag '))
                            .toList(),
                      ),
                    ),
                    Row(
                      children: [
                        TextButton.icon(
                          label: Text(
                            discussions[index].likes.toString(),
                            style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          icon: Icon(
                              hasLiked[index]
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_outlined,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : themeClass.lightPrimaryColor),
                          onPressed: () {
                            setState(
                              () {
                                if (hasLiked[index]) {
                                  discussions[index].likes--;
                                } else {
                                  discussions[index].likes++;
                                }
                                hasLiked[index] = !hasLiked[index];
                              },
                            );
                            // Handle like button press
                          },
                        ),
                        TextButton.icon(
                          label: Text(discussions[index].comments.toString(),
                              style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black)),
                          icon: Icon(Icons.comment,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : themeClass.lightPrimaryColor),
                          onPressed: () {
                            setState(() {});
                            // Handle comment button press
                          },
                        ),
                        const Spacer(),
                        Text(discussions[index].datePosted),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      )
    ]);
  }
}
