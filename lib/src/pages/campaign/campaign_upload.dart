import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neuroparenting/src/db/campaign/campaign_api.dart';
import 'package:neuroparenting/src/homepage.dart';
import 'package:neuroparenting/src/reusable_func/file_picking.dart';

class CampaignUploadPage extends StatefulWidget {
  const CampaignUploadPage({Key? key}) : super(key: key);

  @override
  CampaignUploadPageState createState() => CampaignUploadPageState();
}

class CampaignUploadPageState extends State<CampaignUploadPage> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _image;
  final _filePicking = FilePicking();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload Campaign',
          style: TextStyle(color: Colors.white),
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Get.offAll(
            () => const HomePage(
              indexFromPrevious: 2,
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _urlController,
              decoration: const InputDecoration(labelText: 'Campaign URL'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a campaign URL';
                }
                return null;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: _descriptionController,
              decoration:
                  const InputDecoration(labelText: 'Campaign Description'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a campaign description';
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
            if (_image != null)
              kIsWeb ? Image.network(_image!.path) : Image.file(_image!),
            const SizedBox(height: 16.0),
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () async {
                EasyLoading.show(status: 'Uploading...');
                if (_formKey.currentState!.validate() && _image != null) {
                  final uploadingProcess = await CampaignApi.postCampaign(
                    campaignUrl: _urlController.text,
                    campaignDescription: _descriptionController.text,
                    campaignImage: _image!,
                  );

                  if (uploadingProcess == 'SUCCESS') {
                    Get.snackbar('Success', 'Campaign posted successfully.');
                  } else if (uploadingProcess == 'NOT-ADMIN') {
                    Get.snackbar(
                        'Error', 'You are not authorized to post campaigns.');
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
