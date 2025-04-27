import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  final String userId;

  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFF075E54),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: Future.wait([
          FirebaseFirestore.instance.collection('NewUsers').doc(widget.userId).get(),
          FirebaseFirestore.instance.collection('Profile').doc(widget.userId).get(),
        ]),
        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final newUserData = snapshot.data![0].data() as Map<String, dynamic>? ?? {};
          final profileData = snapshot.data![1].data() as Map<String, dynamic>? ?? {};

          final name = newUserData['name'] ?? "Unknown";
          final email = newUserData['email'] ?? "No email";
          final contact = newUserData['contact']?.toString() ?? "No contact";
          final avatar = profileData['avatar'];
          final bio = profileData['bio'] ?? "Hey there! I am using KDChat.";

          return Column(
            children: [
              const SizedBox(height: 30),
              Center(
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: avatar != null && avatar.toString().isNotEmpty
                      ? AssetImage(avatar) as ImageProvider
                      : null,
                  child: avatar == null || avatar.toString().isEmpty
                      ? const Icon(Icons.person, size: 70)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              
              ListTile(
                leading: const Icon(Icons.email, color: Colors.teal),
                title: const Text("Email"),
                subtitle: Text(email),
              ),
              ListTile(
                leading: const Icon(Icons.phone, color: Colors.teal),
                title: const Text("Contact"),
                subtitle: Text(contact),
              ),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.teal),
                title: const Text("Bio"),
                subtitle: Text(bio),
              ),
            ],
          );
        },
      ),
    );
  }
}
