import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neuroparenting/src/homepage.dart';
import 'package:neuroparenting/src/reusable_comp/language_changer.dart';
import 'package:neuroparenting/src/reusable_comp/theme_changer.dart';
import 'package:neuroparenting/src/reusable_func/localization_change.dart';
import 'package:neuroparenting/src/reusable_func/theme_change.dart';
import 'package:neuroparenting/src/reusable_func/file_picking.dart';
import 'package:permission_handler/permission_handler.dart';

import 'chat_input_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class ChatItem {
  final Content content;
  final Uint8List? image;

  ChatItem({required this.content, this.image});
}

class _ChatBotPageState extends State<ChatBotPage> {
  final ImagePicker picker = ImagePicker();
  final controller = TextEditingController();
  Gemini gemini = Gemini.instance;
  bool _loading = false;
  Uint8List? selectedImage;

  bool get loading => _loading;

  set loading(bool set) => setState(() => _loading = set);
  final List<ChatItem> chats = [];
  final List<Content> chatsTextOnly = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: BackButton(
          onPressed: () => Get.offAll(
            () => const HomePage(
              indexFromPrevious: 0,
            ),
          ),
        ),
        title: const Text(
          'ChatBot Assistant',
        ),
        actions: [
          const LanguageSwitcher(onPressed: localizationChange),
          ThemeSwitcher(onPressed: () {
            setState(() {
              themeChange();
            });
          }),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chats.isNotEmpty
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      reverse: true,
                      child: ListView.builder(
                        itemBuilder: chatItem,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: chats.length,
                        reverse: false,
                      ),
                    ),
                  )
                : Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            Theme.of(context).brightness == Brightness.dark
                                ? 'assets/images/chatbot1_dark.svg'
                                : 'assets/images/chatbot1_light.svg',
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.scaleDown,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'History of chats will be deleted right after you leave.\n\nAsk something...',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          if (loading) const CircularProgressIndicator(),
          // if (selectedImage != null)
          //   ClipRRect(
          //     borderRadius: BorderRadius.circular(16),
          //     child: Image.memory(
          //       selectedImage!,
          //       width: MediaQuery.of(context).size.width * 0.50,
          //       fit: BoxFit.scaleDown,
          //     ),
          //   ),
          ChatInputBox(
            controller: controller,
            onClickCamera: () async {
              final status = await FilePicking().requestPermission();
              if (!status.isGranted) {
                return;
              }
              if (!context.mounted) return;
              final action = await showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Choose an action'),
                  content: const Text(
                      'Pick an image from the gallery or take a new photo?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Gallery'),
                      child: const Text('Gallery'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Camera'),
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

              final XFile? photo = await picker.pickImage(source: source);

              if (photo != null) {
                photo.readAsBytes().then(
                      (value) => setState(
                        () {
                          selectedImage = value;
                        },
                      ),
                    );
              }
            },
            onSend: () async {
              if (controller.text.isNotEmpty) {
                final searchedText = controller.text;
                chats.add(
                  ChatItem(
                      content: Content(
                        role: 'user',
                        parts: [
                          Parts(text: searchedText),
                        ],
                      ),
                      image: selectedImage),
                );
                controller.clear();
                loading = true;

                try {
                  if (selectedImage != null) {
                    await gemini
                        .textAndImage(
                            text: searchedText, images: [selectedImage!])
                        .timeout(const Duration(seconds: 10))
                        .then((value) {
                          chats.add(
                            ChatItem(
                              content: Content(
                                role: 'model',
                                parts: [Parts(text: value?.output)],
                              ),
                            ),
                          );
                        }); // Set a timeout
                  } else {
                    // print(chatsTextOnly);
                    chatsTextOnly.add(Content(
                      role: 'user',
                      parts: [Parts(text: searchedText)],
                    ));

                    await gemini
                        .chat(chatsTextOnly)
                        .timeout(const Duration(seconds: 10))
                        .then((value) {
                      chats.add(
                        ChatItem(
                          content: Content(
                            role: 'model',
                            parts: [
                              Parts(text: value?.output),
                            ],
                          ),
                        ),
                      );
                    }); // Set a timeout
                  }
                } on TimeoutException catch (_) {
                  Get.snackbar('Error', 'Timeout occurred. Please try again.');
                  loading = false; // Stop the Gemini instance
                } catch (e) {
                  Get.snackbar('Error', 'An error occurred. Please try again.');
                  // print(e.toString());
                } finally {
                  loading = false;
                  chatsTextOnly.clear();
                }
              }
            },
            selectedImage: selectedImage,
            onClearImage: () => setState(() => selectedImage = null),
          ),
        ],
      ),
    );
  }

  Widget chatItem(BuildContext context, int index) {
    final ChatItem chatItem = chats[index];
    final Content content = chatItem.content;

    return Card(
      elevation: 0,
      color:
          content.role == 'model' ? Colors.blue.shade800 : Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content.role == 'model' ? 'NeuroParenting Gemini Model' : 'You',
              style: TextStyle(
                  color: content.role == 'model'
                      ? Colors.white
                      : Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black),
            ),
            if (chatItem.image != null)
              Image.memory(chatItem.image!,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.scaleDown),
            Markdown(
                styleSheet: content.role == 'model'
                    ? MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                        p: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white))
                    : MarkdownStyleSheet(),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                data: content.parts?.lastOrNull?.text ??
                    'Unable to generate data.'),
          ],
        ),
      ),
    );
  }
}
