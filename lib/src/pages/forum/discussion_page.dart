// under_construction.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:neuroparenting/src/reusable_comp/language_changer.dart';
import 'package:neuroparenting/src/reusable_comp/theme_changer.dart';
import 'package:neuroparenting/src/reusable_func/form_validator.dart';
import 'package:neuroparenting/src/reusable_func/localization_change.dart';
import 'package:neuroparenting/src/reusable_func/theme_change.dart';
import 'package:neuroparenting/src/homepage.dart';
import 'package:neuroparenting/src/db/forum/forum_api.dart';

class DiscussionPage extends StatefulWidget {
  final String userAvatarUrl;
  final String userName;
  final String userType;
  final String title;
  final List<String> tags;
  final DateTime datePosted;
  final List<String> likes;
  final int likesTotal;
  final int comments;
  final List<Comment> commentsList;
  final String discussionId;
  final String descriptionPost;
  final String discussionImage;
  final bool hasLiked;

  const DiscussionPage(
      {required this.discussionId,
      required this.userAvatarUrl,
      required this.userName,
      required this.userType,
      required this.title,
      required this.descriptionPost,
      required this.tags,
      required this.datePosted,
      required this.likes,
      required this.likesTotal,
      required this.comments,
      required this.commentsList,
      required this.discussionImage,
      required this.hasLiked,
      super.key});

  @override
  DiscussionState createState() => DiscussionState();
}

class DiscussionState extends State<DiscussionPage> {
  final _formKey = GlobalKey<FormState>();
  bool isDarkMode = Get.isDarkMode;
  TextEditingController commentController = TextEditingController();
  FocusNode commentFocusNode = FocusNode();
  bool hasLiked = false;
  int likesTotal = 0;
  List<Comment> commentsList = [];
  int commentTotal = 0;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      hasLiked = widget.hasLiked;
      likesTotal = widget.likes.length;
      commentsList = widget.commentsList;
      commentTotal = commentsList.length;
    } else {
      Get.snackbar('Error', 'Please relog your account.');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: BackButton(
          onPressed: () => Get.offAll(
            () => const HomePage(
              indexFromPrevious: 1,
            ),
          ),
        ),
        title: const Text(
          'Discussion',
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.transparent : Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
              ),
            ),
            child: const LanguageSwitcher(onPressed: localizationChange),
          ),
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.transparent : Colors.white,
            ),
            child: ThemeSwitcher(
              onPressed: () {
                setState(
                  () {
                    themeChange();
                    isDarkMode = !isDarkMode;
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                '  ${widget.title}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),

            ListTile(
              leading: ClipOval(
                child: FadeInImage.assetNetwork(
                  image: widget.userAvatarUrl,
                  placeholder: 'assets/images/placeholder_loading.gif',
                  width: 50, // 2x radius
                  height: 50, // 2x radius
                  fit: BoxFit.cover,
                ),
              ),
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Posted by ',
                      style: DefaultTextStyle.of(context).style,
                    ),
                    TextSpan(
                      text: widget.userName,
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              subtitle: Text(
                DateFormat('yyyy-MM-dd – kk:mm').format(widget.datePosted),
              ),
              trailing: Chip(label: Text(widget.userType)),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Wrap(
                spacing: 6,
                children: widget.tags
                    .map((tag) => Text(
                          '#$tag  ',
                        ))
                    .toList(),
              ),
            ),

            Container(
              height:
                  2.0, // This can be adjusted to change the thickness of the underline
              width: double
                  .infinity, // This will make the underline take up the full width of its parent
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    // Change this to change the color of the underline
                    width:
                        1.0, // Change this to change the thickness of the underline
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(widget.descriptionPost),
            const SizedBox(
              height: 10,
            ),
            FadeInImage.assetNetwork(
              image: widget.discussionImage,
              placeholder: 'assets/images/placeholder_loading.gif',
              width: width * 0.75, // 2x radius
              // 2x radius
              fit: BoxFit.scaleDown,
            ), // Replace with your actual description
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    hasLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                  ),
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await ForumApi.toggleSingleDiscussionLike(
                        discussionId: widget.discussionId,
                        userId: user.uid,
                      );
                      setState(() {
                        hasLiked = !hasLiked;
                        if (hasLiked) {
                          likesTotal++;
                        } else {
                          likesTotal--;
                        }
                      });
                    }
                  },
                ),
                Text('$likesTotal like${likesTotal > 1 ? 's' : ''}'),
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(commentFocusNode);
                  },
                ),
                Text('$commentTotal comment${commentTotal > 1 ? 's' : ''}'),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return TextFormField(
                    validator: FormValidator.validateText,
                    focusNode: commentFocusNode,
                    controller: commentController,
                    decoration: InputDecoration(
                      labelStyle: const TextStyle(
                        color:
                            Colors.black, // Change this to your desired color
                      ),
                      hintText: 'Write a comment...',
                      prefixIcon: const Icon(Icons.comment),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null &&
                                user.photoURL != null &&
                                user.displayName != null) {
                              EasyLoading.show(status: 'Posting comment...');
                              final comment = Comment(
                                text: commentController.text,
                                avatarUrl: user
                                    .photoURL!, // Replace with the URL of the user's avatar
                                commenterName: user
                                    .displayName!, // Replace with the name of the user
                                commenterId:
                                    user.uid, // Replace with the ID of the user
                                commentDate: DateTime.now(),
                              );

                              await ForumApi.postComment(
                                discussionId: widget
                                    .discussionId, // Replace with the ID of the discussion
                                comment: comment,
                              );

                              final updatedComments =
                                  await ForumApi.fetchOnlyComments(
                                      widget.discussionId);

                              commentController.clear();
                              setState(() {
                                commentsList = updatedComments['commentsList'];
                                commentTotal = updatedComments['commentTotal'];
                              });
                              EasyLoading.dismiss();
                            } else {
                              Get.snackbar(
                                  'Error', 'Please relog your account.');
                            }
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              itemCount: commentsList.length,
              itemBuilder: (context, index) {
                final comment = commentsList[index];
                return ListTile(
                  leading: ClipOval(
                    child: FadeInImage.assetNetwork(
                      image: comment.avatarUrl,
                      placeholder: 'assets/images/placeholder_loading.gif',
                      width: 50, // 2x radius
                      height: 50, // 2x radius
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    comment.commenterName,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(comment.text),
                  trailing: Text(DateFormat('yyyy-MM-dd – kk:mm')
                      .format(comment.commentDate)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
