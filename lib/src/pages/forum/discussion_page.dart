// under_construction.dart

import 'package:awesome_dialog/awesome_dialog.dart';
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
import 'package:photo_view/photo_view.dart';

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
  final String discussionPostUserId;
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
      required this.discussionPostUserId,
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
  String userId = "null-string";

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      hasLiked = widget.hasLiked;

      commentsList = widget.commentsList;
      commentTotal = commentsList.length;
      ForumApi.fetchLikesTotalOnly(widget.discussionId).then((likesTotal) {
        setState(() {
          this.likesTotal = likesTotal;
        });
      });
    } else {
      Get.snackbar('Error', 'Please relog your account.');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        Get.offAll(
          () => const HomePage(
            indexFromPrevious: 1,
          ),
        );
      },
      child: Scaffold(
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),
                  ),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  widget.descriptionPost,
                  textAlign: TextAlign.justify,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: Stack(
                        children: [
                          PhotoView(
                            imageProvider: NetworkImage(widget.discussionImage),
                            initialScale: PhotoViewComputedScale.contained,
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.blue),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    FadeInImage.assetNetwork(
                      image: widget.discussionImage,
                      placeholder: 'assets/images/placeholder_loading.gif',
                      width: width * 0.85, // 2x radius
                      fit: BoxFit.scaleDown,
                    ),
                    const Positioned(
                      right: 10,
                      bottom: 10,
                      child: Icon(Icons.zoom_in, color: Colors.blue),
                    ),
                  ],
                ),
              ),
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
                  if (userId == widget.discussionPostUserId)
                    IconButton(
                      icon: const Icon(Icons.delete),
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
                            final result = await ForumApi.deleteDiscussion(
                              discussionId: widget.discussionId,
                            );

                            switch (result) {
                              case 'NULL':
                                Get.snackbar(
                                    'Error', 'Please relog your account.');
                                break;
                              case 'NOT-OWNER':
                                Get.snackbar('Error',
                                    'You do not have permission to delete this discussion.');
                                break;
                              case 'SUCCESS':
                                Get.snackbar('Success',
                                    'Discussion deleted successfully.');
                                Get.offAll(
                                  () => const HomePage(
                                    indexFromPrevious: 1,
                                  ),
                                );
                                break;
                            }
                          },
                        ).show();
                      },
                    ),
                  if (userId == widget.discussionPostUserId)
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {},
                    )
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
                                  commenterId: user.uid,
                                  commentId: "",
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
                                  commentsList =
                                      updatedComments['commentsList'];
                                  commentTotal =
                                      updatedComments['commentTotal'];
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
              Column(
                children: List.generate(
                  commentsList.length,
                  (index) {
                    final Comment comment = commentsList[index];
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
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(
                              '${comment.commenterName} | ',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateFormat('yyyy-MM-dd – kk:mm  ')
                                  .format(comment.commentDate),
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 12),
                            ),
                            if (userId == comment.commenterId)
                              InkWell(
                                onTap: () async {
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
                                        EasyLoading.show(
                                            status: "Deleting comment...");
                                        String result =
                                            await ForumApi.deleteComment(
                                          discussionId: widget.discussionId,
                                          commentId: comment.commentId,
                                        );
                                        switch (result) {
                                          case 'NULL':
                                            Get.snackbar('Error',
                                                'Please relog your account.');
                                            break;
                                          case 'NOT-OWNER':
                                            Get.snackbar('Error',
                                                'You do not have permission to delete this comment.');
                                            break;
                                          case 'SUCCESS':
                                            Get.snackbar('Success',
                                                'Comment deleted successfully.');
                                            final updatedComments =
                                                await ForumApi
                                                    .fetchOnlyComments(
                                                        widget.discussionId);
                                            setState(() {
                                              commentsList = updatedComments[
                                                  'commentsList'];
                                              commentTotal = updatedComments[
                                                  'commentTotal'];
                                            });
                                            break;
                                        }
                                        EasyLoading.dismiss();
                                      }).show();
                                },
                                child: const Icon(
                                  Icons.delete,
                                ),
                              ),
                          ],
                        ),
                      ),
                      subtitle: Text(
                        comment.text,
                        textAlign: TextAlign.justify,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
