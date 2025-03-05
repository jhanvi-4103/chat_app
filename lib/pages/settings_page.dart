import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kd_chat/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('Setting'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey,
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          // Toggle the theme when the entire container is tapped
          Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(25),
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Dark mode text
              const Text('Dark Mode',
              style: TextStyle(
                fontWeight:FontWeight.bold,
                fontSize: 16,
              ),),
              
              // Cupertino switch
              CupertinoSwitch(
                value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
                onChanged: (value) {
                  // Toggle the theme when the switch is toggled
                  Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
