// forum.dart

import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:neuroparenting/src/reusable_func/form_validator.dart';
import 'package:neuroparenting/src/theme/theme.dart';
import 'package:get/get.dart';
import 'package:neuroparenting/src/db/forum/forum_api.dart';
import 'package:neuroparenting/src/reusable_func/file_picking.dart';

import 'discussion_page.dart';
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
  final titlePostController = TextEditingController();
  final descriptionPostController = TextEditingController();
  final tagPostController = TextEditingController();
  final searchController = TextEditingController();
  List<Discussion> filteredDiscussions = [];
  final themeClass = ThemeClass();
  File? newPostImage;
  List<bool> hasLiked = [];
  List<bool> hasLikedFiltered = [];
  int current = 0;
  String userType = 'Parent';
  bool isDarkMode = Get.isDarkMode;
  Map<String, bool> tagCheckboxes = {
    'DCD': false,
    'Dyslexia': false,
    'ADHD': false,
    'Others': false,
  };
  final _formKey = GlobalKey<FormState>();
  bool likeChanged = false;

  List<Discussion> discussions = [];

  void filterDiscussions() {
    List<Discussion> newFilteredDiscussions = [];
    List<bool> newHasLikedFiltered = [];

    for (var discussion in discussions) {
      bool shouldInclude = discussion.title.toLowerCase().contains(
                searchController.text.toLowerCase(),
              ) ||
          discussion.descriptionPost.toLowerCase().contains(
                searchController.text.toLowerCase(),
              ) ||
          discussion.tags.any(
            (tag) => tag.split(',').any(
                  (individualTag) => individualTag
                      .toLowerCase()
                      .trim()
                      .replaceFirst('#', '')
                      .contains(
                        searchController.text
                            .toLowerCase()
                            .replaceFirst('#', ''),
                      ),
                ),
          );

      if (shouldInclude) {
        newFilteredDiscussions.add(discussion);
        newHasLikedFiltered.add(hasLiked[discussions.indexOf(discussion)]);
      }
    }
    setState(() {
      filteredDiscussions = newFilteredDiscussions;
      hasLikedFiltered = newHasLikedFiltered;
    });
  }

  @override
  void initState() {
    super.initState();
    current = widget.current;
    isDarkMode = Get.isDarkMode;
    fetchDiscussions().then((_) {
      hasLiked = List<bool>.filled(discussions.length, false);
      filterDiscussions();
      searchController.addListener(filterDiscussions);
    });
  }

  final user = FirebaseAuth.instance.currentUser;

  Future<void> fetchDiscussions() async {
    EasyLoading.show(status: 'Loading Forum...');
    final fetchedDiscussions = await ForumApi.fetchDiscussions();

    discussions = fetchedDiscussions;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case when the user is not signed in
      EasyLoading.dismiss();
      Get.snackbar(
          'Error', 'Failed to fetch discussions, you\'re not logged in.');
      return;
    }

    final hasLikedFetched = fetchedDiscussions
        .map((discussion) => discussion.likes.contains(user.uid))
        .toList();

    setState(() {
      discussions = fetchedDiscussions;
      filteredDiscussions = discussions;
      hasLikedFiltered = hasLikedFetched;
    });
    EasyLoading.dismiss();
  }

  @override
  Widget build(context) {
    return RefreshIndicator(
      onRefresh: fetchDiscussions,
      child: Column(
        children: [
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
                      keyboardType: TextInputType.visiblePassword,
                      controller: searchController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                            Theme.of(context).brightness == Brightness.dark
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
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
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
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                            scrollable: true,
                            title: const Text('Post Discussion'),
                            content: StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return SingleChildScrollView(
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          validator:
                                              FormValidator.validateTitle,
                                          controller: titlePostController,
                                          decoration: const InputDecoration(
                                            labelText: 'Title',
                                          ),
                                        ),
                                        TextFormField(
                                          validator: FormValidator.validateText,
                                          controller: descriptionPostController,
                                          decoration: const InputDecoration(
                                            labelText: 'Description',
                                          ),
                                          maxLines: null,
                                          keyboardType: TextInputType.multiline,
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
                                                  tagCheckboxes[entry.key] =
                                                      value!;
                                                });
                                              },
                                            );
                                          },
                                        ).toList(),
                                        ElevatedButton(
                                          onPressed: () async {
                                            final filePicking = FilePicking();

                                            final action =
                                                await showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: const Text(
                                                    'Choose an action'),
                                                content: const Text(
                                                    'Pick an image from the gallery or take a new photo?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'Gallery'),
                                                    child:
                                                        const Text('Gallery'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'Camera'),
                                                    child: const Text('Camera'),
                                                  ),
                                                ],
                                              ),
                                            );

                                            ImageSource source;
                                            if (action == 'Gallery') {
                                              source = ImageSource.gallery;
                                            } else if (action == 'Camera') {
                                              source = ImageSource.camera;
                                            } else {
                                              // The user cancelled the dialog
                                              return;
                                            }

                                            newPostImage = await filePicking
                                                .pickImage(source);
                                            setState(() {});
                                          },
                                          child: const Text('Choose Photo'),
                                        ),
                                        if (newPostImage != null)
                                          Image.file(
                                            newPostImage!,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75,
                                            fit: BoxFit.cover,
                                          )
                                        else
                                          const Text('No image selected'),
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              if (newPostImage != null) {
                                                EasyLoading.show(
                                                    status: 'Posting...');
                                                await ForumApi.postDiscussion(
                                                    titlePost:
                                                        titlePostController
                                                            .text,
                                                    descriptionPost:
                                                        descriptionPostController
                                                            .text,
                                                    tagCheckboxes:
                                                        tagCheckboxes,
                                                    newPostImage: newPostImage!,
                                                    userType: userType);
                                                setState(() {
                                                  newPostImage == null;
                                                });
                                                await fetchDiscussions();
                                                EasyLoading.dismiss();
                                              } else {
                                                Get.snackbar('Error',
                                                    'Make sure you have entered all fields, chosen a photo, and connected to internet.');
                                              }
                                              if (!context.mounted) return;
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: const Text('Post Discussion'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              newPostImage == null;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                      ],
                                    ),
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
              itemCount: filteredDiscussions.length,
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
                                image: filteredDiscussions[index].userAvatarUrl,
                                placeholder:
                                    'assets/images/placeholder_loading.gif',
                                width: 50, // 2x radius
                                height: 50, // 2x radius
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: widget.width * 0.025),
                            Text(filteredDiscussions[index].userName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const Spacer(),
                            Chip(
                                label:
                                    Text(filteredDiscussions[index].userType)),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            filteredDiscussions[index].title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Wrap(
                            spacing: 10,
                            children: filteredDiscussions[index]
                                .tags
                                .map((tag) => Text('#$tag '))
                                .toList(),
                          ),
                        ),
                        Row(
                          children: [
                            TextButton.icon(
                              label: Text(
                                filteredDiscussions[index]
                                    .likesTotal
                                    .toString(),
                                style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              icon: Icon(
                                  hasLikedFiltered[index]
                                      ? Icons.thumb_up
                                      : Icons.thumb_up_outlined,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.black
                                      : themeClass.lightPrimaryColor),
                              onPressed: () async {
                                if (hasLikedFiltered[index]) {
                                  await ForumApi.likeOrDislikeDiscussion(
                                      discussionId: filteredDiscussions[index]
                                          .discussionId);
                                  setState(
                                    () {
                                      --filteredDiscussions[index].likesTotal;
                                    },
                                  );
                                } else {
                                  await ForumApi.likeOrDislikeDiscussion(
                                      discussionId: filteredDiscussions[index]
                                          .discussionId);
                                  setState(
                                    () {
                                      ++filteredDiscussions[index].likesTotal;
                                    },
                                  );
                                }
                                setState(() {
                                  hasLikedFiltered[index] =
                                      !hasLikedFiltered[index];
                                  likeChanged = true;
                                });

                                // Handle like button press
                              },
                            ),
                            TextButton.icon(
                              label: Text(
                                filteredDiscussions[index].comments.toString(),
                                style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              icon: Icon(Icons.comment,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.black
                                      : themeClass.lightPrimaryColor),
                              onPressed: () {
                                Get.offAll(
                                  () => DiscussionPage(
                                    hasLiked: hasLikedFiltered[index],
                                    discussionId:
                                        filteredDiscussions[index].discussionId,
                                    userAvatarUrl: filteredDiscussions[index]
                                        .userAvatarUrl,
                                    userName:
                                        filteredDiscussions[index].userName,
                                    userType:
                                        filteredDiscussions[index].userType,
                                    title: filteredDiscussions[index].title,
                                    descriptionPost: filteredDiscussions[index]
                                        .descriptionPost,
                                    discussionImage: filteredDiscussions[index]
                                        .discussionImage,
                                    tags: filteredDiscussions[index].tags,
                                    datePosted:
                                        filteredDiscussions[index].datePosted,
                                    likes: filteredDiscussions[index].likes,
                                    likesTotal:
                                        filteredDiscussions[index].likesTotal,
                                    comments:
                                        filteredDiscussions[index].comments,
                                    commentsList:
                                        filteredDiscussions[index].commentsList,
                                  ),
                                );
                                // Handle comment button press
                              },
                            ),
                            const Spacer(),
                            Text(
                              DateFormat('dd-MM-yyyy').format(
                                filteredDiscussions[index].datePosted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
