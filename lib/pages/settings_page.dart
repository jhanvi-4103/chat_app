import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kd_chat/pages/about_us.dart';
import 'package:kd_chat/pages/user_page.dart';
import 'package:kd_chat/services/auth/auth_service.dart';
import 'package:kd_chat/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final containerColor = theme.colorScheme.secondary;
    final textColor = theme.colorScheme.onSecondary;
      final auth = AuthService();
    // ignore: unused_local_variable
    final user = auth.getCurrentUser();

    Widget settingsTile({
      required IconData icon,
      required String title,
      required VoidCallback onTap,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            height: 50,
            child: Row(
              children: [
                Icon(icon, color: textColor),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
    
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20), 

            // Dark Mode toggle at top
            GestureDetector(
              onTap: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dark Mode',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                      CupertinoSwitch(
                        value: Provider.of<ThemeProvider>(context).isDarkMode,
                        onChanged: (value) {
                          Provider.of<ThemeProvider>(context, listen: false)
                              .toggleTheme();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Profile
            settingsTile(
              icon: Icons.person,
              title: 'Profile',
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserProfilePage(),
                    ));
              },
            ),

            // About Us
            settingsTile(
              icon: Icons.info,
              title: 'About Us',
              onTap: () {
               Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutUsPage(),
                    ));
              },
            ),

            // Logout
            settingsTile(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () {
                auth.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
