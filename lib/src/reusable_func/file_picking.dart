import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FilePicking {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage() async {
    final status = await _requestPermission();
    if (!status.isGranted) {
      return null;
    }

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return null;
    }
  }

  Future<String?> pickImagePath() async {
    final status = await _requestPermission();
    if (!status.isGranted) {
      return null;
    }

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return pickedFile.path;
    } else {
      return null;
    }
  }

  Future<PermissionStatus> _requestPermission() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (Platform.isAndroid && androidInfo.version.sdkInt >= 33) {
      return await Permission.photos.request();
    } else {
      return await Permission.storage.request();
    }
  }
}
