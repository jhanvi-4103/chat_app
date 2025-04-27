import 'package:flutter/material.dart';
import 'package:kd_chat/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kd_chat/pages/user_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final user = auth.getCurrentUser();
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            // User Info Section
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('NewUsers')
                  .doc(user?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return _buildHeader(context, name: "Guest");
                }
                final userData = snapshot.data!.data() as Map<String, dynamic>?;
                return _buildHeader(
                  context,
                  name: userData?['name'] ?? "Guest",
                  avatar: userData?['avatar'],
                );
              },
            ),

            const Divider(thickness: 1, height: 1),

            // Centered Menu Items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 20.0),
              
              child: Center(
              
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDrawerItem(
                      context,
                      Icons.home_rounded,
                      "H O M E",
                      () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 16),
                    _buildDrawerItem(
                      context,
                      Icons.person_rounded,
                      "P R O F I L E",
                      () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserProfilePage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Spacer(flex: 1),
            const Divider(thickness: 1, height: 1),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Made with by KD ",
                style: theme.textTheme.bodySmall?.copyWith(
                  // ignore: deprecated_member_use
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // User Header Widget
  Widget _buildHeader(BuildContext context,
      {required String name, String? avatar}) {
    final theme = Theme.of(context);
    String defaultAvatar = "assets/avatars/avatar3.png";

    ImageProvider imageProvider;

    if (avatar != null && avatar.isNotEmpty) {
      if (avatar.startsWith('http')) {
        imageProvider = NetworkImage(avatar);
      } else if (avatar.startsWith('assets/')) {
        imageProvider = AssetImage(avatar);
      } else {
        imageProvider = AssetImage(defaultAvatar);
      }
    } else {
      imageProvider = AssetImage(defaultAvatar);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      color: theme.colorScheme.primary,
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: theme.colorScheme.onPrimary,
            backgroundImage: imageProvider,
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Drawer Item Widget
  Widget _buildDrawerItem(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      // ignore: deprecated_member_use
      hoverColor: theme.colorScheme.primary.withOpacity(0.1),
      onTap: onTap,
    );
  }
}
