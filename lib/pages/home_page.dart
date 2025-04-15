import 'package:flutter/material.dart';
import 'package:kd_chat/components/my_drawer.dart';
import 'package:kd_chat/components/user_tile.dart';
import 'package:kd_chat/pages/chat_page.dart';
import 'package:kd_chat/services/auth/auth_service.dart';
import 'package:kd_chat/services/chat/chat_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "H O M E",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 20 : 28,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 8.0 : 24.0,
          vertical: isSmallScreen ? 10.0 : 16.0,
        ),
        child: _buildUserList(context),
      ),
    );
  }

  Widget _buildUserList(BuildContext context) {
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
        final currentUserId = _authService.getCurrentUser()?.uid;

        if (currentUserId == null) {
          return const Center(child: Text('User not found.'));
        }

        final userList = snapshot.data!
            .where((userData) => userData['email'] != currentUserEmail)
            .toList();

        if (userList.isEmpty) {
          return const Center(child: Text('No other users found.'));
        }

        return ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            final userData = userList[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: UserTile(
                userId: userData['uid'],
                currentUserId: currentUserId,
                onTap: () {
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
              ),
            );
          },
        );
      },
    );
  }
}
