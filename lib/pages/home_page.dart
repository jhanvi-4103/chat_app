import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:kd_chat/components/my_drawer.dart';
import 'package:kd_chat/components/user_tile.dart';
import 'package:kd_chat/pages/chat_page.dart';
import 'package:kd_chat/pages/settings_page.dart';
import 'package:kd_chat/services/auth/auth_service.dart';
import 'package:kd_chat/services/chat/chat_service.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  int _currentIndex = 0;

  Future<void> _handleRefresh() async {
    setState(() {}); // Triggers rebuild
    await Future.delayed(const Duration(seconds: 1)); // Optional delay
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    final List<Widget> pages = [
      _buildUserList(context),
      const SettingsPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0 ? "H O M E" : "S E T T I N G",
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

      // Curved Bottom Nav Bar
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Theme.of(context).colorScheme.primary,
        buttonBackgroundColor: Theme.of(context).colorScheme.secondary,
        animationDuration: const Duration(milliseconds: 300),
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.settings, size: 30, color: Colors.white),
        ],
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),

      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/bg2.png',
              fit: BoxFit.cover,
            ),
          ),

          // Page content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 8.0 : 24.0,
              vertical: isSmallScreen ? 10.0 : 16.0,
            ),
            child: pages[_currentIndex],
          ),
        ],
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

        return LiquidPullToRefresh(
          onRefresh: _handleRefresh,
          showChildOpacityTransition: false,
          animSpeedFactor: 2.0,
          height: 180,
          color: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: ListView.builder(
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
          ),
        );
      },
    );
  }
}
