import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neuroparenting/src/db/article/article_api.dart';
import 'package:neuroparenting/src/reusable_func/file_picking.dart';

class UploadArticlePage extends StatefulWidget {
  const UploadArticlePage({super.key});

  @override
  UploadArticlePageState createState() => UploadArticlePageState();
}

class UploadArticlePageState extends State<UploadArticlePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  File? _image;
  final _filePicking = FilePicking();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Article'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _bodyController,
              decoration: const InputDecoration(labelText: 'Body'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a body';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              child: const Text('Select Image'),
              onPressed: () async {
                final pickedFile =
                    await _filePicking.pickImage(ImageSource.gallery);
                setState(() {
                  _image = pickedFile;
                });
              },
            ),
            if (_image != null) Image.file(_image!),
            const SizedBox(height: 16.0),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () async {
                EasyLoading.show(status: 'Uploading...');
                if (_formKey.currentState!.validate() && _image != null) {
                  final uploadingProcess = await ArticleApi.postArticle(
                    title: _titleController.text,
                    body: _bodyController.text,
                    image: _image!,
                  );

                  if (uploadingProcess == 'Success') {
                    Get.snackbar('Success', 'Articles posted successfully.');
                  } else {
                    Get.snackbar('Error', 'Something went wrong, check logs.');
                  }
                }
                EasyLoading.dismiss();
              },
            ),
          ],
        ),
      ),
    );
  }
}
