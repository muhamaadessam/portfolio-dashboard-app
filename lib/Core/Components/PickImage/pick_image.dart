import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

Future<File?> pickImage() async {
  FilePickerResult? result;
  String? fileName;
  PlatformFile? pickedFile;
  File? fileToDisplay;
  try {
    result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      fileName = result.files.first.name;
      pickedFile = result.files.first;
      fileToDisplay = File(pickedFile.path.toString());
    }
    debugPrint(fileName);

    return fileToDisplay;
  } catch (error) {
    debugPrint(error.toString());
    rethrow;
  }
}
