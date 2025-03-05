// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart';

class ImagePickerComponent {
  final ImagePicker _picker = ImagePicker();
  final SupabaseClient supabase = Supabase.instance.client;

  /// Picks an image from the given [source] (Gallery or Camera)
  Future<File?> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      return image != null ? File(image.path) : null;
    } catch (e) {
      print("Error picking image: $e");
      return null;
    }
  }

  Future<String?> uploadImageToSupabase(File image) async {
    try {
      final String fileName = basename(image.path);
      final String filePath = 'chat_images/$fileName';

      // Convert image to Uint8List
      final Uint8List fileBytes = await image.readAsBytes().then((bytes) => Uint8List.fromList(bytes));

      // Upload image to Supabase Storage
      await supabase.storage.from('images').uploadBinary(filePath, fileBytes);

      // Return the public URL of the uploaded image
      return supabase.storage.from('images').getPublicUrl(filePath);
    } catch (e) {
      print('Upload failed: $e');
      return null;
    }
  }
  /// Shows a bottom sheet for the user to pick an image source
  void showImageSourceDialog(BuildContext context, Function(File?) onImagePicked) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('Take a Photo', style: TextStyle(fontSize: 16)),
                onTap: () async {
                  Navigator.pop(context);
                  File? image = await pickImage(ImageSource.camera);
                  onImagePicked(image);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image, color: Colors.green),
                title: const Text('Choose from Gallery', style: TextStyle(fontSize: 16)),
                onTap: () async {
                  Navigator.pop(context);
                  File? image = await pickImage(ImageSource.gallery);
                  onImagePicked(image);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
