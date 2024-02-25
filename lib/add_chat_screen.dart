import 'package:flutter/material.dart';
import 'package:my_chat_app/user_tile.dart';
import 'package:my_chat_app/widgets/my_text_field.dart';

import 'auth_service.dart';
import 'chat_page.dart';
import 'chat_service.dart';

class AddChatScreen extends StatefulWidget {
  const AddChatScreen({Key? key}) : super(key: key);

  @override
  _AddChatScreenState createState() => _AddChatScreenState();
}

class _AddChatScreenState extends State<AddChatScreen> {
  TextEditingController controller = TextEditingController();
  final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        title: const Text("Новое сообщение"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10,bottom: 5),
            child: MyTextField(
              hintText: "Поиск",
              obscureText: false,
              controller: controller,
              onChanged: (text) {
                // Вызываем setState для обновления экрана при изменении текста в TextField
                setState(() {});
              },
            ),
          ),
          // StreamBuilder should be used as a widget
          StreamBuilder(
            stream: _chatService.getAllUsers(),
            builder: (context, snapshot) {
              if (controller.text.trim().isEmpty) {
                return Container();
              }
              if (snapshot.hasError) {
                return Text("Ошибка: ${snapshot.error.toString()}");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Загрузка");
              }

              List filteredUsers = (snapshot.data as List).where((userData) {
                return userData["email"].toString().toLowerCase().startsWith(controller.text.toLowerCase());
              }).toList();

              // Wrap your ListView in an Expanded to avoid rendering issues
              return Expanded(
                child: ListView(
                  children: filteredUsers.map<Widget>((userData) => _buildUserListItem(userData, context)).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget functions should be inside the class
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    final AuthService _authService = AuthService();
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
