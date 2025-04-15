// ignore_for_file: unused_import, unnecessary_import

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_auth;
import 'package:path/path.dart';
import 'package:kd_chat/models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final supabase_auth.SupabaseClient _supabase = supabase_auth.Supabase.instance.client;

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> sendMessage(String receiverID, {String? text, String? imageUrl}) async {
    try {
      final firebase_auth.User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        if (kDebugMode) print("Error: User not logged in.");
        return;
      }

      final String currentUserID = currentUser.uid;
      final String currentUserEmail = currentUser.email!;
      final Timestamp timestamp = Timestamp.now();

      if (text == null && imageUrl == null) {
        if (kDebugMode) print("Error: Either text or imageUrl must be provided.");
        return;
      }

      Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: text ?? '',
        imageUrl: imageUrl ?? '',
        timestamp: timestamp,
      );

      String chatRoomID = _generateChatRoomID(currentUserID, receiverID);

      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection('messages')
          .add(newMessage.toMap());

      if (kDebugMode) print("Message sent successfully.");
    } catch (e) {
      if (kDebugMode) print("Failed to send message: $e");
    }
  }

Future<void> sendImageMessage(String receiverID, String imageUrl) async {
  try {
    await sendMessage(receiverID, imageUrl: imageUrl);

    if (kDebugMode) print(" Image message sent with Cloudinary URL: $imageUrl");
  } catch (e) {
    if (kDebugMode) print(" Failed to send image message: $e");
  }
}

  Stream<QuerySnapshot> getMessages(String userID, String otherID) {
    String chatRoomID = _generateChatRoomID(userID, otherID);
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> deleteMessage(String messageID, String userID, String otherID) async {
    try {
      String chatRoomID = _generateChatRoomID(userID, otherID);
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection('messages')
          .doc(messageID)
          .delete();

      if (kDebugMode) print("Message deleted successfully.");
    } catch (e) {
      if (kDebugMode) print("Failed to delete message: $e");
    }
  }

  Future<void> markMessageAsDeleted(String messageID, String userID, String otherID) async {
    try {
      String chatRoomID = _generateChatRoomID(userID, otherID);
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection('messages')
          .doc(messageID)
          .update({'message': 'This message was deleted.', 'isDeleted': true});

      if (kDebugMode) print("Message marked as deleted.");
    } catch (e) {
      if (kDebugMode) print("Failed to mark message as deleted: $e");
    }
  }

  String _generateChatRoomID(String userID1, String userID2) {
    List<String> ids = [userID1, userID2];
    ids.sort();
    return ids.join('_');
  }
}
