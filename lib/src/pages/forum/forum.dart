// forum.dart

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:neuroparenting/src/db/forum/forum_api.dart';
import 'package:neuroparenting/src/reusable_func/file_picking.dart';
import 'package:neuroparenting/src/reusable_func/form_validator.dart';
import 'package:neuroparenting/src/theme/theme.dart';

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
  bool isLikingOrDisliking = false;

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
        int originalIndex = discussions.indexOf(discussion);
        newHasLikedFiltered.add(hasLiked[originalIndex]);
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
    hasLiked = List<bool>.filled(discussions.length, false);
    fetchDiscussions().then((_) {
      filterDiscussions();
      searchController.addListener(filterDiscussions);
    });
  }

  final user = FirebaseAuth.instance.currentUser;

  Future<void> fetchDiscussions() async {
    EasyLoading.show(status: 'Loading Forum...');
    final fetchedDiscussions = await ForumApi.fetchDiscussions();
    final fetchedUserType = await ForumApi.fetchUserType();

    discussions = fetchedDiscussions;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case when the user is not signed in
      EasyLoading.dismiss();
      Get.snackbar(
          'Error', 'Failed to fetch discussions, you\'re not logged in.');
      return;
    }

    hasLiked = fetchedDiscussions
        .map((discussion) => discussion.likes.contains(user.uid))
        .toList();

    setState(() {
      userType = fetchedUserType;
      discussions = fetchedDiscussions;
      filterDiscussions(); // Call filterDiscussions here
    });
    EasyLoading.dismiss();
  }

  @override
  Widget build(context) {
    return RefreshIndicator(
      onRefresh: fetchDiscussions,
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color.fromARGB(255, 211, 227, 253)
          : ThemeClass.lightTheme.primaryColor,
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
                      controller: searchController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? const Color.fromARGB(255, 3, 21, 37)
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
                            ? const Color.fromARGB(255, 211, 227, 253)
                            : Colors.white),
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                            // backgroundColor: themeClass.darkRounded, set from theme.dart
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
                                              checkColor: Colors.white,
                                              activeColor: isDarkMode
                                                  ? const Color.fromARGB(
                                                      255, 3, 21, 37)
                                                  : ThemeClass()
                                                      .lightPrimaryColor,
                                              title: Text(entry.key),
                                              value: entry.value,
                                              onChanged: (bool? value) {
                                                setState(
                                                  () {
                                                    tagCheckboxes[entry.key] =
                                                        value!;
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        ).toList(),
                                        ElevatedButton(
                                          // style: ElevatedButton.styleFrom(
                                          //     backgroundColor:
                                          //         const Color.fromARGB(
                                          //             255, 3, 21, 37)),
                                          onPressed: () async {
                                            final filePicking = FilePicking();

                                            final action =
                                                await showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 3, 21, 37),
                                                title: Text(
                                                  'Choose an action',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.white
                                                          : Colors.black),
                                                ),
                                                content: Text(
                                                  'Pick an image from the gallery or take a new photo?',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.white
                                                          : Colors.black),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'Gallery'),
                                                    child: Text(
                                                      'Gallery',
                                                      style: TextStyle(
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? Colors.white
                                                              : Colors.black),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'Camera'),
                                                    child: Text(
                                                      'Camera',
                                                      style: TextStyle(
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? Colors.white
                                                              : Colors.black),
                                                    ),
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
                                          child: const Text(
                                            'Choose Photo',
                                          ),
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
                                          // style: ElevatedButton.styleFrom(
                                          //     backgroundColor:
                                          //         const Color.fromARGB(
                                          //             255, 3, 21, 37)),
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
                                                  newPostImage = null;
                                                });
                                                await fetchDiscussions();
                                                EasyLoading.dismiss();
                                                if (!context.mounted) return;
                                                Navigator.of(context).pop();
                                              } else {
                                                Get.snackbar('Error',
                                                    'Make sure you have entered all fields, chosen a photo, and connected to internet.');
                                                EasyLoading.dismiss();
                                              }
                                            }
                                          },
                                          child: const Text(
                                            'Post Discussion',
                                          ),
                                        ),
                                        ElevatedButton(
                                          // style: ElevatedButton.styleFrom(
                                          //     backgroundColor:
                                          //         const Color.fromARGB(
                                          //             255, 3, 21, 37)),
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
                return GestureDetector(
                  onTap: () {
                    Get.offAll(
                      () => DiscussionPage(
                        hasLiked: hasLikedFiltered[index],
                        discussionId: filteredDiscussions[index].discussionId,
                        userAvatarUrl: filteredDiscussions[index].userAvatarUrl,
                        userName: filteredDiscussions[index].userName,
                        userType: filteredDiscussions[index].userType,
                        title: filteredDiscussions[index].title,
                        descriptionPost:
                            filteredDiscussions[index].descriptionPost,
                        discussionImage:
                            filteredDiscussions[index].discussionImage,
                        tags: filteredDiscussions[index].tags,
                        datePosted: filteredDiscussions[index].datePosted,
                        postEditedAt: filteredDiscussions[index].postEditedAt,
                        likes: filteredDiscussions[index].likes,
                        likesTotal: filteredDiscussions[index].likesTotal,
                        comments: filteredDiscussions[index].comments,
                        commentsList: filteredDiscussions[index].commentsList,
                        discussionPostUserId:
                            filteredDiscussions[index].discussionPostUserId,
                      ),
                    );
                  },
                  child: Card(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? themeClass.darkRounded
                        : const Color.fromARGB(255, 243, 243, 243),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipOval(
                                child: FadeInImage.assetNetwork(
                                  image:
                                      filteredDiscussions[index].userAvatarUrl,
                                  placeholder:
                                      'assets/images/placeholder_loading.gif',
                                  width: 50, // 2x radius
                                  height: 50, // 2x radius
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: widget.width * 0.025),
                              Text(
                                filteredDiscussions[index].userName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Chip(
                                label:
                                    Text(filteredDiscussions[index].userType),
                                backgroundColor: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? const Color.fromARGB(255, 3, 21, 37)
                                    : Colors.white,
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              filteredDiscussions[index].title,
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                                          ? const Color.fromARGB(
                                              255, 211, 227, 253)
                                          : Colors.black),
                                ),
                                icon: Icon(
                                    hasLikedFiltered[index]
                                        ? Icons.thumb_up
                                        : Icons.thumb_up_outlined,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? const Color.fromARGB(
                                            255, 211, 227, 253)
                                        : themeClass.lightPrimaryColor),
                                onPressed: () async {
                                  if (isLikingOrDisliking) {
                                    // If a like/dislike operation is already in progress, do nothing
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.warning,
                                      animType: AnimType.bottomSlide,
                                      title: 'Please wait...',
                                      desc:
                                          'Slow down folk, the like/dislike operation is on progress.',
                                      dismissOnTouchOutside: false,
                                      dismissOnBackKeyPress: false,
                                      btnOkOnPress: () {},
                                    ).show();
                                    return;
                                  }

                                  isLikingOrDisliking = true;

                                  if (hasLikedFiltered[index]) {
                                    await ForumApi.likeOrDislikeDiscussion(
                                        discussionId: filteredDiscussions[index]
                                            .discussionId);
                                    setState(
                                      () {
                                        --filteredDiscussions[index].likesTotal;
                                        hasLikedFiltered[index] = false;
                                      },
                                    );
                                  } else {
                                    await ForumApi.likeOrDislikeDiscussion(
                                        discussionId: filteredDiscussions[index]
                                            .discussionId);
                                    setState(
                                      () {
                                        ++filteredDiscussions[index].likesTotal;
                                        hasLikedFiltered[index] = true;
                                      },
                                    );
                                  }

                                  likeChanged = true;
                                  isLikingOrDisliking = false;
                                },
                              ),
                              TextButton.icon(
                                label: Text(
                                  filteredDiscussions[index]
                                      .commentsList
                                      .length
                                      .toString(),
                                  style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? const Color.fromARGB(
                                              255, 211, 227, 253)
                                          : Colors.black),
                                ),
                                icon: Icon(Icons.comment,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? const Color.fromARGB(
                                            255, 211, 227, 253)
                                        : themeClass.lightPrimaryColor),
                                onPressed: () {
                                  Get.offAll(
                                    () => DiscussionPage(
                                      hasLiked: hasLikedFiltered[index],
                                      discussionId: filteredDiscussions[index]
                                          .discussionId,
                                      userAvatarUrl: filteredDiscussions[index]
                                          .userAvatarUrl,
                                      userName:
                                          filteredDiscussions[index].userName,
                                      userType:
                                          filteredDiscussions[index].userType,
                                      title: filteredDiscussions[index].title,
                                      descriptionPost:
                                          filteredDiscussions[index]
                                              .descriptionPost,
                                      discussionImage:
                                          filteredDiscussions[index]
                                              .discussionImage,
                                      tags: filteredDiscussions[index].tags,
                                      datePosted:
                                          filteredDiscussions[index].datePosted,
                                      postEditedAt: filteredDiscussions[index]
                                          .postEditedAt,
                                      likes: filteredDiscussions[index].likes,
                                      likesTotal:
                                          filteredDiscussions[index].likesTotal,
                                      comments:
                                          filteredDiscussions[index].comments,
                                      commentsList: filteredDiscussions[index]
                                          .commentsList,
                                      discussionPostUserId:
                                          filteredDiscussions[index]
                                              .discussionPostUserId,
                                    ),
                                  );
                                  // Handle comment button press
                                },
                              ),
                              if (user != null &&
                                  user!.uid ==
                                      filteredDiscussions[index]
                                          .discussionPostUserId)
                                TextButton.icon(
                                  label: const Text(""),
                                  icon: Icon(Icons.delete,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? const Color.fromARGB(
                                              255, 211, 227, 253)
                                          : themeClass.lightPrimaryColor),
                                  onPressed: () async {
                                    AwesomeDialog(
                                      dismissOnTouchOutside: false,
                                      context: context,
                                      keyboardAware: true,
                                      dismissOnBackKeyPress: false,
                                      dialogType: DialogType.question,
                                      animType: AnimType.scale,
                                      transitionAnimationDuration:
                                          const Duration(milliseconds: 200),
                                      btnOkText: "Delete",
                                      btnCancelText: "Cancel",
                                      title: 'Delete Discussion',
                                      desc:
                                          "Are you sure you want to delete this discussion?",
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () async {
                                        String result =
                                            await ForumApi.deleteDiscussion(
                                          discussionId:
                                              filteredDiscussions[index]
                                                  .discussionId,
                                        );
                                        if (result == "SUCCESS") {
                                          setState(() {
                                            filteredDiscussions.removeAt(index);
                                          });
                                          Get.snackbar('Success',
                                              'Discussion deleted successfully.');
                                        } else if (result == "NOT-OWNER") {
                                          Get.snackbar('Error',
                                              'You are not the owner of this discussion.');
                                        } else {
                                          Get.snackbar('Error',
                                              'Failed to delete discussion.');
                                        }
                                      },
                                    ).show();
                                  },
                                ),
                              const Spacer(),
                              Text(
                                filteredDiscussions[index].datePosted ==
                                        filteredDiscussions[index].postEditedAt
                                    ? DateFormat('dd-MM-yyyy').format(
                                        filteredDiscussions[index].datePosted,
                                      )
                                    : "Edited at ${DateFormat('dd-MM-yyyy').format(
                                        filteredDiscussions[index].postEditedAt,
                                      )}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
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
