// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kd_chat/components/chat_bubble.dart';
import 'package:kd_chat/components/fullSCreenImage.dart';
import 'package:kd_chat/components/image_picker.dart';

import 'package:kd_chat/components/my_text_field.dart';
import 'package:kd_chat/pages/call_page.dart';
import 'package:kd_chat/pages/profile_page.dart';
import 'package:kd_chat/services/auth/auth_service.dart';
import 'package:kd_chat/services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiversEmail;
  final String receiverID;

  const ChatPage({
    super.key,
    required this.receiversEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final ImagePicker _picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();

  void _showCallDialog() {
    TextEditingController callIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Enter Call ID"),
        content: TextField(
          controller: callIdController,
          decoration: const InputDecoration(hintText: "Call ID"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              String callID = callIdController.text.trim();
              if (callID.isNotEmpty) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CallPage(callID: callID)),
                );
              }
            },
            child: const Text("Start Call"),
          ),
        ],
      ),
    );
  }

  void sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      await _chatService.sendMessage(
        widget.receiverID,
        text: _messageController.text.trim(),
        imageUrl: '',
      );
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
    final pickerComponent = ImagePickerComponent();

    pickerComponent.showImageSourceDialog(context, (File? imageFile) async {
      if (imageFile != null) {
        // Upload image to Cloudinary
        final imageUrl =
            await pickerComponent.uploadImageToCloudinary(imageFile);

        if (imageUrl != null && imageUrl.isNotEmpty) {
          // Send the image URL as a message
          await _chatService.sendImageMessage(
            widget.receiverID,
            imageUrl,
            imageFile.path.split('/').last,
          );
        } else {
          // Show error if upload fails
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to upload image")),
          );
        }
      }
    });
  }

  Future<void> deleteMessage(String messageId) async {
    FocusScope.of(context).requestFocus(FocusNode());
    await _chatService.markMessageAsDeleted(
      messageId,
      _authService.getCurrentUser()!.uid,
      widget.receiverID,
    );
  }

  void markMessagesAsRead(String senderId, String receiverId) {
    FirebaseFirestore.instance
        .collection('messages')
        .where('senderId', isEqualTo: senderId)
        .where('receiverId', isEqualTo: receiverId)
        .where('isRead', isEqualTo: false)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.update({'isRead': true});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    markMessagesAsRead(widget.receiverID, _authService.getCurrentUser()!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  foregroundColor: Colors.grey,
  title: StreamBuilder<DocumentSnapshot>(
    stream: FirebaseFirestore.instance
        .collection('NewUsers')
        .doc(widget.receiverID)
        .snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData || snapshot.data == null) {
        return const Text("Loading...");
      }

      final userData =
          snapshot.data!.data() as Map<String, dynamic>? ?? {};
      final String name = userData['name'] ?? 'Unknown';
      final String? avatar = userData['avatar'];
      final bool isOnline = userData['isOnline'] ?? false;
      final Timestamp? lastSeenTimestamp = userData['lastSeen'];
      final DateTime? lastSeen = lastSeenTimestamp?.toDate();

      String getLastSeenText() {
        if (isOnline) return "Online";
        if (lastSeen == null) return "Last seen recently";
        final now = DateTime.now();
        final difference = now.difference(lastSeen);

        if (difference.inMinutes < 1) return "Just now";
        if (difference.inMinutes < 60) {
          return "${difference.inMinutes} min ago";
        }
        if (difference.inHours < 24) {
          return "${difference.inHours} hours ago";
        }
        return "${lastSeen.day}/${lastSeen.month}/${lastSeen.year}";
      }

      return Row(
        children: [
          GestureDetector(
            onTap: () {
              // Navigate to ProfilePage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(userId: widget.receiverID),
                ),
              );
            },
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey,
                  backgroundImage: (avatar != null && avatar.startsWith('http'))
                      ? NetworkImage(avatar)
                      : AssetImage(
                          (avatar != null && avatar.isNotEmpty)
                              ? avatar
                              : 'assets/avatars/avatar2.png',
                        ) as ImageProvider,
                ),
                if (isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 18)),
              Text(
                getLastSeenText(),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: _showCallDialog,
            icon: const Icon(Icons.videocam, size: 30, color: Colors.green),
          ),
        ],
      );
    },
  ),
),

      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg2.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Foreground Chat UI
          Column(
            children: [
              Expanded(child: _buildMessageList()),
              _buildUserInput(),
            ],
          ),
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
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()?.uid;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    bool isDeleted = data['isDeleted'] == true;

    return GestureDetector(
      onLongPress: isCurrentUser && !isDeleted
          ? () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Delete Message"),
                  content: const Text(
                      "Are you sure you want to delete this message?"),
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
                      child: const Text("Delete",
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              )
          : null,
      child: Container(
        alignment: alignment,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (data.containsKey('imageUrl') &&
                data['imageUrl'] != null &&
                data['imageUrl'].toString().isNotEmpty &&
                !isDeleted)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FullScreenImage(imageUrl: data['imageUrl']),
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
              ChatBubble(
                isCurrentUser: isCurrentUser,
                message: "This message was deleted.",
              ),
            if (!isDeleted &&
                data['message'] != null &&
                data['message'].toString().isNotEmpty)
              ChatBubble(
                isCurrentUser: isCurrentUser,
                message: data['message'],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, left: 10, right: 5),
      child: Row(
        children: [
          IconButton(
            onPressed: sendImageMessage,
            icon: const Icon(
              Icons.image,
              color: Colors.blue,
              size: 30,
            ),
          ),
          Expanded(
            child: MyTextField(
              hintText: "Type a message",
              obsecureText: false,
              controller: _messageController,
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.send,
              color: Colors.green,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
