import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:portfolio_app/Core/AppData/app_data.dart';

Future<Uint8List?> pickImage() async {
  try {
    final picker = ImagePicker();

    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (file == null) return null;

    final Uint8List bytes = await file.readAsBytes();

    return bytes;
  } catch (e) {
    rethrow;
  }
}

Future<String> uploadImageToCloudinary(Uint8List imageBytes) async {
  print('==> uploadImageToCloudinary $imageBytes');
  try {
    const cloudName = 'dxty2amiw';
    const uploadPreset = 'portfolio_uploads';
    final Dio dio = DioHelper.dio!;

    final url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

    final formData = FormData.fromMap({
      'upload_preset': uploadPreset,
      'file': MultipartFile.fromBytes(imageBytes, filename: 'project.png'),
    });

    final response = await dio.post(url, data: formData);
    print('==> ${response.data}');
    return response.data['secure_url'];
  } catch (e) {
    print('==> $e');
    rethrow;
  }
}
