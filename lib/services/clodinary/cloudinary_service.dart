
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class CloudinaryService {
  final cloudinary = CloudinaryPublic(
    'dig6hkhhz',
    'CHAT-APP',
    cache: false,
  );

  Future<String> uploadImage(Uint8List imageBytes) async {
    try {
      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final fileName = 'chat_image_${DateTime.now().millisecondsSinceEpoch}.png';
      final filePath = join(tempDir.path, fileName);

      // Write Uint8List to file
      final file = await File(filePath).writeAsBytes(imageBytes);

      // Upload file to Cloudinary
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(file.path, folder: 'chat_images'),
      );

      return response.secureUrl;
    } catch (e) {
      if (kDebugMode) {
        print("Error uploading to Cloudinary: $e");
      }
      return '';
    }
  }
}
