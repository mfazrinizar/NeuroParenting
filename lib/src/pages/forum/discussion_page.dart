// under_construction.dart

import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:neuroparenting/src/db/push_notification/push_notification_api.dart';
import 'package:neuroparenting/src/reusable_comp/language_changer.dart';
import 'package:neuroparenting/src/reusable_comp/theme_changer.dart';
import 'package:neuroparenting/src/reusable_func/file_picking.dart';
import 'package:neuroparenting/src/reusable_func/form_validator.dart';
import 'package:neuroparenting/src/reusable_func/localization_change.dart';
import 'package:neuroparenting/src/reusable_func/theme_change.dart';
import 'package:neuroparenting/src/homepage.dart';
import 'package:neuroparenting/src/db/forum/forum_api.dart';
import 'package:neuroparenting/src/theme/theme.dart';
import 'package:photo_view/photo_view.dart';

class DiscussionPage extends StatefulWidget {
  final String userAvatarUrl;
  final String userName;
  final String userType;
  final String title;
  final List<String> tags;
  final DateTime datePosted;
  final DateTime postEditedAt;
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
      required this.postEditedAt,
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
  final discussionTitlePostController = TextEditingController();
  final discussionDescriptionPostController = TextEditingController();
  final discussionTagPostController = TextEditingController();
  final discussionSearchController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _editFormKey = GlobalKey<FormState>();
  bool isDarkMode = Get.isDarkMode;
  TextEditingController commentController = TextEditingController();
  FocusNode commentFocusNode = FocusNode();
  bool hasLiked = false;
  int likesTotal = 0;
  List<Comment> commentsList = [];
  int commentTotal = 0;
  String userId = "null-string";
  File? newPostImage;
  Map<String, bool> tagCheckboxes = {
    'DCD': false,
    'Dyslexia': false,
    'ADHD': false,
    'Others': false,
  };
  Discussion? updatedDiscussion;
  String userType = 'Parent';

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      hasLiked = widget.hasLiked;

      commentsList = updatedDiscussion?.commentsList ?? widget.commentsList;
      commentTotal =
          updatedDiscussion?.commentsList.length ?? commentsList.length;
      ForumApi.fetchLikesTotalOnly(
              updatedDiscussion?.discussionId ?? widget.discussionId)
          .then((likesTotal) {
        setState(() {
          this.likesTotal = likesTotal;
        });
      });
    } else {
      Get.snackbar('Error', 'Please relog your account.');
    }
  }

  Future<void> refreshDiscussion() async {
    final fetchedUpdatedDiscussion =
        await ForumApi.fetchOnlyOneDiscussion(widget.discussionId);
    setState(() {
      updatedDiscussion = fetchedUpdatedDiscussion;
      commentsList = updatedDiscussion!.commentsList;
      commentTotal = updatedDiscussion!.commentsList.length;
    });
  }

  Future<void> postComment() async {
    if (_editFormKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.photoURL != null && user.displayName != null) {
        EasyLoading.show(status: 'Posting comment...');
        final pushNotificationApi = PushNotificationAPI();
        final comment = Comment(
          text: commentController.text,
          avatarUrl: user.photoURL!,
          commenterName: user.displayName!,
          commenterId: user.uid,
          commentId: "",
          commentDate: DateTime.now(),
        );

        await ForumApi.postComment(
          discussionId: widget.discussionId,
          comment: comment,
        );

        List<String> commenterUserIds =
            commentsList.map((comment) => comment.commenterId).toList();

        pushNotificationApi.notifyUsersWithDiscussionId(
          commentBody: commentController.text,
          discussionId: widget.discussionId,
          posterUserId: widget.discussionPostUserId,
          commenterUserIds: commenterUserIds,
        );

        final updatedComments = await ForumApi.fetchOnlyComments(
            updatedDiscussion?.discussionId ?? widget.discussionId);

        commentController.clear();
        setState(() {
          commentsList = updatedComments['commentsList'];
          commentTotal = updatedComments['commentTotal'];
        });
        EasyLoading.dismiss();
        Get.snackbar('Success', 'Comment posted.');
      } else {
        EasyLoading.dismiss();
        Get.snackbar('Error', 'Please relog your account.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      onRefresh: refreshDiscussion,
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color.fromARGB(255, 211, 227, 253)
          : ThemeClass.lightTheme.primaryColor,
      child: PopScope(
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
              const LanguageSwitcher(onPressed: localizationChange),
              ThemeSwitcher(
                color: isDarkMode
                    ? const Color.fromARGB(255, 211, 227, 253)
                    : Colors.black,
                onPressed: () {
                  setState(
                    () {
                      themeChange();
                      isDarkMode = !isDarkMode;
                    },
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: SelectableText(
                      updatedDiscussion?.title ?? widget.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ),
                ),
                ListTile(
                  leading: ClipOval(
                    child: FadeInImage.assetNetwork(
                      image: updatedDiscussion?.userAvatarUrl ??
                          widget.userAvatarUrl,
                      placeholder: 'assets/images/placeholder_loading.gif',
                      width: 50, // 2x radius
                      height: 50, // 2x radius
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: SelectableText.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Posted by ',
                          style: DefaultTextStyle.of(context).style,
                        ),
                        TextSpan(
                          text: updatedDiscussion?.userName ?? widget.userName,
                          style: DefaultTextStyle.of(context)
                              .style
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  subtitle: SelectableText(
                    (updatedDiscussion?.datePosted ?? widget.datePosted) ==
                            (updatedDiscussion?.postEditedAt ??
                                widget.postEditedAt)
                        ? DateFormat('yyyy-MM-dd – kk:mm').format(
                            updatedDiscussion?.datePosted ?? widget.datePosted)
                        : "Edited at ${DateFormat('yyyy-MM-dd – kk:mm').format(updatedDiscussion?.postEditedAt ?? widget.postEditedAt)}",
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Chip(
                      label: SelectableText(
                          updatedDiscussion?.userType ?? widget.userType)),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Wrap(
                    spacing: 6,
                    children: (updatedDiscussion?.tags ?? widget.tags)
                        .map((tag) => SelectableText(
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
                  child: SelectableText(
                    updatedDiscussion?.descriptionPost ??
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
                              imageProvider: NetworkImage(
                                  updatedDiscussion?.discussionImage ??
                                      widget.discussionImage),
                              initialScale: PhotoViewComputedScale.contained,
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: IconButton(
                                icon:
                                    const Icon(Icons.close, color: Colors.blue),
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
                        image: updatedDiscussion?.discussionImage ??
                            widget.discussionImage,
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
                            discussionId: updatedDiscussion?.discussionId ??
                                widget.discussionId,
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
                    if (userId ==
                        (updatedDiscussion?.discussionPostUserId ??
                            widget.discussionPostUserId))
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
                                discussionId: updatedDiscussion?.discussionId ??
                                    widget.discussionId,
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
                    if (userId ==
                        (updatedDiscussion?.discussionPostUserId ??
                            widget.discussionPostUserId))
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Initialize the controllers with the existing discussion details
                          discussionTitlePostController.text =
                              updatedDiscussion?.title ?? widget.title;
                          discussionDescriptionPostController.text =
                              updatedDiscussion?.descriptionPost ??
                                  widget.descriptionPost;
                          tagCheckboxes = {
                            for (var entry in tagCheckboxes.entries)
                              entry.key:
                                  (updatedDiscussion?.tags ?? widget.tags)
                                      .contains(entry.key),
                          };
                          userType =
                              updatedDiscussion?.userType ?? widget.userType;

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                scrollable: true,
                                title: const Text('Edit Discussion'),
                                content: StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return SingleChildScrollView(
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              validator:
                                                  FormValidator.validateTitle,
                                              controller:
                                                  discussionTitlePostController,
                                              decoration: const InputDecoration(
                                                labelText: 'Title',
                                              ),
                                            ),
                                            TextFormField(
                                              validator:
                                                  FormValidator.validateText,
                                              controller:
                                                  discussionDescriptionPostController,
                                              decoration: const InputDecoration(
                                                labelText: 'Description',
                                              ),
                                              maxLines: null,
                                              keyboardType:
                                                  TextInputType.multiline,
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
                                                final filePicking =
                                                    FilePicking();

                                                final action =
                                                    await showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    title: const Text(
                                                        'Choose an action'),
                                                    content: Text(
                                                      'Pick an image from the gallery or take a new photo?',
                                                      style: TextStyle(
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? Colors.white
                                                              : Colors.black),
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context,
                                                                'Gallery'),
                                                        child: Text(
                                                          'Gallery',
                                                          style: TextStyle(
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .dark
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context,
                                                                'Camera'),
                                                        child: Text(
                                                          'Camera',
                                                          style: TextStyle(
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .dark
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black),
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
                                              child: const Text('Change Photo'),
                                            ),
                                            if (newPostImage != null && !kIsWeb)
                                              Image.file(
                                                newPostImage!,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.75,
                                                fit: BoxFit.cover,
                                              )
                                            else if (kIsWeb &&
                                                newPostImage != null)
                                              Image.network(
                                                newPostImage!.path,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.75,
                                                fit: BoxFit.cover,
                                              )
                                            else
                                              Image.network(
                                                updatedDiscussion
                                                        ?.discussionImage ??
                                                    widget.discussionImage,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.75,
                                                fit: BoxFit.cover,
                                              ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  EasyLoading.show(
                                                      status: 'Updating...');
                                                  await ForumApi.editDiscussion(
                                                    discussionId:
                                                        updatedDiscussion
                                                                ?.discussionId ??
                                                            widget.discussionId,
                                                    titlePost:
                                                        discussionTitlePostController
                                                            .text,
                                                    descriptionPost:
                                                        discussionDescriptionPostController
                                                            .text,
                                                    tagCheckboxes:
                                                        tagCheckboxes,
                                                    newPostImage: newPostImage,
                                                    userType: userType,
                                                  );

                                                  setState(() {
                                                    newPostImage = null;
                                                    refreshDiscussion();
                                                  });

                                                  EasyLoading.dismiss();
                                                  if (!context.mounted) return;
                                                  Navigator.of(context).pop();
                                                } else {
                                                  Get.snackbar('Error',
                                                      'Make sure all of the forms are not empty and you are connected to internet.');
                                                  EasyLoading.dismiss();
                                                }
                                              },
                                              child: const Text(
                                                  'Update Discussion'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                setState(() {
                                                  newPostImage = null;
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
                const SizedBox(
                  height: 10,
                ),
                Form(
                  key: _editFormKey,
                  child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return TextFormField(
                        validator: FormValidator.validateText,
                        focusNode: commentFocusNode,
                        controller: commentController,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(
                            color: Colors
                                .black, // Change this to your desired color
                          ),
                          hintText: 'Write a comment...',
                          prefixIcon: const Icon(Icons.comment),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: postComment,
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
                            placeholder:
                                'assets/images/placeholder_loading.gif',
                            width: 50, // 2x radius
                            height: 50, // 2x radius
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SelectableText(
                                '${comment.commenterName} | ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              SelectableText(
                                DateFormat('yyyy-MM-dd – kk:mm  ')
                                    .format(comment.commentDate),
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12),
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
                                        title: 'Delete Comment',
                                        desc:
                                            "Are you sure you want to delete this comment?",
                                        btnCancelOnPress: () {},
                                        btnOkOnPress: () async {
                                          EasyLoading.show(
                                              status: "Deleting comment...");
                                          String result =
                                              await ForumApi.deleteComment(
                                            discussionId: updatedDiscussion
                                                    ?.discussionId ??
                                                widget.discussionId,
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
                                                  await ForumApi.fetchOnlyComments(
                                                      updatedDiscussion
                                                              ?.discussionId ??
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
                        subtitle: SelectableText(
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
      ),
    );
  }
}
