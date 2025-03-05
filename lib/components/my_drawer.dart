import 'package:flutter/material.dart';
import 'package:kd_chat/services/auth/auth_service.dart';
import 'package:kd_chat/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  void logout() {
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //logo
              DrawerHeader(
                child: Center(
                  child: Icon(Icons.message,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
              //home list title
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title: const Text("H O M E"),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    // pop the drawer
                    Navigator.pop(context);
                  },
                ),
              ),
              //setting list title.
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: ListTile(
                  title:const Text("S E T T I N G"),
                  leading: const Icon(Icons.settings),
                  onTap: () {
                    // Navigate to Settings page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          //logout list title
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
            child: ListTile(
              title: const Text("L O G O U T"),
              leading: const Icon(Icons.logout),
              onTap: logout ,
            ),
          ),
        ],
      ),
    );
  }
}
