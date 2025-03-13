import 'package:flutter/material.dart';
import 'package:kd_chat/services/auth/auth_service.dart';
import 'package:kd_chat/pages/settings_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final user = auth.getCurrentUser();
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: Column(
        children: [
          // User Info Section
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('Users').doc(user?.uid).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return _buildHeader(context, email: "", avatar: "");
              }
              final userData = snapshot.data!.data() as Map<String, dynamic>?;
              return _buildHeader(
                context,
                email: userData?['email'] ?? "",
                avatar: userData?['avatar'],
              );
            },
          ),

          // **Menu Items**
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(context, Icons.home, "Home", () => Navigator.pop(context)),
                _buildDrawerItem(context, Icons.settings, "Settings", () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                }),
              ],
            ),
          ),

          // **Logout Section**
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListTile(
              leading: Icon(Icons.logout, color:Colors.red, size: 30,),
              title: Text(
                "Logout",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                auth.signOut();
              },
            ),
          ),
        ],
      ),
    );
  }

  // **User Header Widget**
  Widget _buildHeader(BuildContext context, {required String email, String? avatar}) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      color: theme.colorScheme.primary,
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: theme.colorScheme.onPrimary,
            backgroundImage: avatar != null && avatar.isNotEmpty
                ? NetworkImage(avatar)
                : const AssetImage("assets/avatars/avatar4.png") as ImageProvider,
          ),
          const SizedBox(height: 12),
          Text(
            email,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // **Helper Method for Drawer Items**
  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }
}
