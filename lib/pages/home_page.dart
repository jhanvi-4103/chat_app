import 'package:flutter/material.dart';
import 'package:kd_chat/components/my_drawer.dart';
import 'package:kd_chat/components/user_tile.dart';
import 'package:kd_chat/pages/chat_page.dart';
import 'package:kd_chat/services/auth/auth_service.dart';
import 'package:kd_chat/services/chat/chat_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // Chat & Auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("H O M E", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  // Build a list of users except for the current logged-in user.
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading users'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentUserEmail = _authService.getCurrentUser()?.email;
        final currentUserId = _authService.getCurrentUser()?.uid; // Get Current User ID

        if (currentUserId == null) {
          return const Center(child: Text('User not found.'));
        }

        // Filter out the logged-in user and build the list
        final userList = snapshot.data!
            .where((userData) => userData['email'] != currentUserEmail)
            .toList();

        return ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            final userData = userList[index];
            return UserTile(
              userId: userData['uid'],
              currentUserId: currentUserId, // Pass Current User ID
              onTap: () {
                // Navigate to ChatPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      receiversEmail: userData["email"],
                      receiverID: userData['uid'],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
