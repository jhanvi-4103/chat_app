// ignore_for_file: deprecated_member_use
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kd_chat/components/chat_bubble.dart';
import 'package:kd_chat/components/fullSCreenImage.dart' show FullScreenImage;
import 'package:kd_chat/components/my_text_field.dart';
import 'package:kd_chat/services/auth/auth_service.dart';
import 'package:kd_chat/services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiversEmail;
  final String receiverID;

  const ChatPage({super.key, required this.receiversEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();

  void sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      await _chatService.sendMessage(widget.receiverID, text: _messageController.text.trim());
      _messageController.clear();
      _scrollToBottom();
    }
  }

  Future<void> _scrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> sendImageMessage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Uint8List imageBytes = await pickedFile.readAsBytes();
      String fileName = pickedFile.name;
      await _chatService.sendImageMessage(widget.receiverID, imageBytes, fileName);
    }
  }

  Future<void> deleteMessage(String messageId) async {
    FocusScope.of(context).requestFocus(FocusNode());
    await _chatService.markMessageAsDeleted(messageId, _authService.getCurrentUser()!.uid, widget.receiverID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiversEmail),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading messages'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()?.uid;
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    bool isDeleted = data['isDeleted'] == true;

    return GestureDetector(
      onLongPress: isCurrentUser && !isDeleted
          ? () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Delete Message"),
                  content: const Text("Are you sure you want to delete this message?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        deleteMessage(doc.id);
                        Navigator.pop(context);
                      },
                      child: const Text("Delete", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              )
          : null,
      child: Container(
        alignment: alignment,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (data.containsKey('imageUrl') && data['imageUrl'] != null && data['imageUrl'].toString().isNotEmpty && !isDeleted)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImage(imageUrl: data['imageUrl']),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    data['imageUrl'],
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            if (isDeleted)
              ChatBubble(isCurrentUser: isCurrentUser, message: "This message was deleted."),
            if (!isDeleted && data['message'] != null && data['message'].toString().isNotEmpty)
              ChatBubble(isCurrentUser: isCurrentUser, message: data['message']),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0, left: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: sendImageMessage,
            icon: const Icon(Icons.image, color: Colors.blue),
          ),
          Expanded(
            child: MyTextField(
              hintText: "Type a message",
              obsecureText: false,
              controller: _messageController,
            ),
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
            margin: const EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}