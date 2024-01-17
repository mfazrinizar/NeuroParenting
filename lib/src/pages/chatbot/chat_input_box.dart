import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'item_image_view.dart';

class ChatInputBox extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onSend, onClickCamera, onClearImage;
  final Uint8List? selectedImage;

  const ChatInputBox({
    super.key,
    this.controller,
    this.onSend,
    this.onClickCamera,
    this.selectedImage,
    this.onClearImage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (selectedImage == null)
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: IconButton(
                onPressed: onClickCamera,
                icon: const Icon(Icons.image),
              ),
            ),
          if (selectedImage != null)
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: IconButton(
                onPressed: onClearImage,
                icon: const Icon(Icons.hide_image),
              ),
            ),
          if (selectedImage != null) ItemImageView(bytes: selectedImage!),
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 6,
              cursorColor: Theme.of(context).colorScheme.inversePrimary,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                hintText: 'Ask here...',
                border: InputBorder.none,
              ),
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4),
            child: FloatingActionButton.small(
              onPressed: onSend,
              child: const Icon(Icons.send_rounded),
            ),
          )
        ],
      ),
    );
  }
}
