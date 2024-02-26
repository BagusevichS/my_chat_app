import 'package:flutter/material.dart';
import 'package:my_chat_app/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {

  final String message;
  final bool isCurrentUser;

  const ChatBubble({Key? key, required this.message, required this.isCurrentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context,listen: false).isDarkMode;
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 2.5,horizontal: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isCurrentUser
            ? isDarkMode ? Color(0xFF113B63) : Theme.of(context).colorScheme.onBackground
            : isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
      ),
      child: Text(
        message,
        style: TextStyle(color: isCurrentUser?Colors.white:(isDarkMode?Colors.white:Colors.black)),),
    );
  }
}
