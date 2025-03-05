import 'package:flutter/material.dart';
import 'package:kd_chat/components/my_drawer.dart';
import 'package:kd_chat/components/user_tile.dart';
import 'package:kd_chat/pages/chat_page.dart';
import 'package:kd_chat/services/auth/auth_service.dart';
import 'package:kd_chat/services/chat/chat_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

// chat & Auth service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  void logout() {
    // get auth service
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  // build a list of user except for thr current logged in user.
  Widget _buildUserList() {
    return StreamBuilder(
        stream: _chatService.getUsersStream(),
        builder: (context, snapshot) {
          // error
          if (snapshot.hasError) {
            return const Text('Error');
          }

          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading..');
          }

          // return ListView
          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (userData) => _buildUserListItem(userData, context))
                .toList(),
          );
        });
  }

  // build individual list tile for user
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // display all user except current user
    if (userData['email'] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData['email'],
        onTap: () {
          // tapped on a user -> goto chat page

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiversEmail: userData["email"],
                  receiverID: userData['uid'],
                ),
              ));
        },
      );
   }  else {
        return Container();
      }
    }
  }

