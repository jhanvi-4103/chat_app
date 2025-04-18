import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class CloudinaryService {
  final String cloudName = 'dig6hkhhz';
  final String uploadPreset = 'CHAT-APP';

  Future<String> uploadImage(Uint8List imageBytes) async {
    try {
      final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = uploadPreset
        ..files.add(http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: 'chat_image.jpg',
        ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        final data = jsonDecode(res.body);
        return data['secure_url'];
      } else {
        throw Exception('Cloudinary upload failed with status ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) print('Cloudinary upload failed: $e');
      return '';
    }
  }
}
