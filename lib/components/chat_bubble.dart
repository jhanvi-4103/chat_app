import 'package:flutter/material.dart';
import 'package:kd_chat/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final bool isDeleted;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    this.isDeleted = false,
  });

  @override
  Widget build(BuildContext context) {
   
    bool isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: isDeleted
            ? Colors.grey.shade500
            : isCurrentUser
                ? (isDarkMode ? Colors.green.shade600 : Colors.green.shade500)
                : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 25),
      child: Text(
        isDeleted ? "This message is deleted." : message,
        style: TextStyle(
          fontStyle: isDeleted ? FontStyle.italic : FontStyle.normal,
          color: isDeleted
              ? Colors.black54
              : isDarkMode
                  ? Colors.white
                  : Colors.black,
        ),
      ),
    );
  }
}