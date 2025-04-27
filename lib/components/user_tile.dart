import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String userId;
  final void Function()? onTap;
  final String currentUserId; // Needed to fetch unread messages

  const UserTile({super.key, required this.userId, required this.onTap, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('NewUsers').doc(userId).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return _buildTile(context, "Loading...", "", 0, onTap);
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>?;
        final String name = userData?['name'] ?? "Unknown";
        final String avatarUrl = userData?['avatar'] ?? "";

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('messages')
              .where('senderId', isEqualTo: userId)
              .where('receiverId', isEqualTo: currentUserId)
              .where('isRead', isEqualTo: false) // Filter unread messages
              .snapshots(),
          builder: (context, unreadSnapshot) {
            int unreadCount = 0;
            if (unreadSnapshot.hasData) {
              unreadCount = unreadSnapshot.data!.docs.length;
            }

            return _buildTile(context, name, avatarUrl, unreadCount, onTap);
          },
        );
      },
    );
  }

  Widget _buildTile(BuildContext context, String name, String avatarUrl, int unreadCount, void Function()? onTap) {
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
            Expanded(
              child: Text(name, style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSecondary, fontWeight: FontWeight.bold)),
            ),

            // Unread Messages Counter
            if (unreadCount > 0)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  unreadCount.toString(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
