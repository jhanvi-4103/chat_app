import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String userId;
  final void Function()? onTap;

  const UserTile({super.key, required this.userId, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('NewUsers').doc(userId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return _buildTile(context, "Loading...", "", onTap);
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>?;
        final String name = userData?['name'] ?? "Unknown";
        final String avatarUrl = userData?['avatar'] ?? "";

        return _buildTile(context, name, avatarUrl, onTap);
      },
    );
  }

  Widget _buildTile(BuildContext context, String name, String avatarUrl, void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // User Avatar
            CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.primary,
              backgroundImage: avatarUrl.startsWith("http") 
                  ? NetworkImage(avatarUrl)
                  : AssetImage(avatarUrl) as ImageProvider,
              child: avatarUrl.isEmpty ? const Icon(Icons.person, color: Colors.white) : null,
            ),

            const SizedBox(width: 20),

            // Username
            Text(name, style: Theme.of(context).textTheme.bodyMedium,),
          ],
        ),
      ),
    );
  }
}
