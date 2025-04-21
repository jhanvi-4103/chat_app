import 'package:flutter/material.dart';
import 'package:kd_chat/pages/home_page.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  // Method to launch a URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
              (Route<dynamic> route) => false,
            );
          },
        ),
        title: const Text('About Us', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
        backgroundColor: theme.primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App logo and intro
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/kdChat.png', 
                    height: 100,
                  ),
                  
                  const SizedBox(height: 8),
                  Text(
                    'Connect. Vibe. Communicate.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // About app
            Text(
              'Who We Are',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'KD Chat is your ultimate communication platform designed to connect people based on vibes and shared interests. We’re building a safe, fun, and interactive space where users can chat, call, and video call freely with features inspired by modern social trends.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Key Features:\n'
              '• Secure login and registration\n'
              '• Profile customization with pictures and preferences\n'
              '• Text, voice, and video chats\n'
              '• Search users by username, location, age, or vibe\n'
              '• Whatsapp-inspired UI & user experience\n',
            
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),

            // Contact card
            Text(
              'Contact Us',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.phone, color: Colors.blue),
                      title: const Text('Phone'),
                      subtitle: const Text('+91 9904225520'),
                      onTap: () => _launchURL('tel:+919904225520'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.email, color: Colors.red),
                      title: const Text('Email'),
                      subtitle: const Text('kteam4work@gmail.com'),
                      onTap: () => _launchURL('mailto:kteam4work@gmail.com'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.green),
                      title: const Text('Address'),
                      subtitle: const Text(
                        '45, Radhe Residency, near Naira petrol pump,\nKhambhat, Gujarat 388620',
                      ),
                      onTap: () => _launchURL("https://maps.app.goo.gl/ofp5dFsmf21MKzSWA"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Footer
            Center(
              child: Text(
                '© 2025 KD Chat. All Rights Reserved.',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
