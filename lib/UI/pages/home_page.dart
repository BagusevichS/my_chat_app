import 'package:flutter/material.dart';
import 'package:my_chat_app/domain/services/auth_service.dart';
import 'package:my_chat_app/domain/services/chat_service.dart';
import 'package:my_chat_app/themes/theme_provider.dart';
import 'package:my_chat_app/widgets/user_tile.dart';
import 'package:provider/provider.dart';

import 'add_chat_screen.dart';
import 'chat_page.dart';
import '../../widgets/my_drawer.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();


  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context,listen: false).isDarkMode;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text("Мой чат"),
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      drawer: MyDrawer(),
      body: _buildUserList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddChatScreen()));
        },
        backgroundColor: isDarkMode ? Color(0xFF113B63):Theme.of(context).colorScheme.onBackground,
        child: const Icon(Icons.add,color: Colors.white,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Ошибка: ${snapshot.error.toString()}");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Загрузка");
        }

        return ListView(
          children: snapshot.data!.map<Widget>((userData) => _buildUserListItem(userData, context)).toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          Navigator.push(
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
