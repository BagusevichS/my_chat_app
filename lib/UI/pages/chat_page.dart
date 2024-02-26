import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/domain/services/auth_service.dart';
import 'package:my_chat_app/widgets/chat_bubble.dart';
import 'package:my_chat_app/domain/services/chat_service.dart';
import 'package:my_chat_app/themes/theme_provider.dart';
import 'package:my_chat_app/widgets/my_text_field.dart';
import 'package:provider/provider.dart';

import '../../domain/functions.dart';

class ChatPage extends StatefulWidget {

  final String receiverEmail;
  final String receiverID;

  ChatPage({Key? key, required this.receiverEmail, required this.receiverID}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  FocusNode myFocusNode = FocusNode();

  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if(myFocusNode.hasFocus){
        Future.delayed(const Duration(milliseconds: 500),()=>scrollDown(_scrollController));
      }
    });
    Future.delayed(const Duration(milliseconds: 500),()=>scrollDown(_scrollController));
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();

  }




  void sendMessage() async {
    if(_messageController.text.trim().isNotEmpty){
      await _chatService.sendMessage(widget.receiverID, _messageController.text.trim());
      _messageController.clear();
      scrollDown(_scrollController);
    }
    scrollDown(_scrollController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList(){
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(stream: _chatService.getMessages(widget.receiverID, senderID), builder: (context,snapshot){
      if(snapshot.hasError){
        return Text("Ошибка");
      }
      if(snapshot.connectionState == ConnectionState.waiting){
        return Text("Загрузка");
      }
      Widget listView = ListView(
        controller: _scrollController,
        children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
      return listView;
    });
  }

  Widget _buildMessageItem(DocumentSnapshot doc){

    Map<String,dynamic> data = doc.data() as Map<String,dynamic>;

    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;


    return Container(
        child: Column(
          crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubble(message: data["message"], isCurrentUser: isCurrentUser),
          ],
        )
    );
  }

  Widget _buildUserInput(){
    //bool isDarkMode = Provider.of<ThemeProvider>(context,listen: false).isDarkMode;
    return Padding(
      padding: const EdgeInsets.only(bottom: 50,top: 5),
      child: Row(
        children: [
          Expanded(
              child: MyTextField(
                  focusNode: myFocusNode,
                  hintText: "Введите сообщение",
                  obscureText: false, controller: _messageController

              )
          ),
          Container(
              decoration: BoxDecoration(
                color: Color(0xFF2C9E76),
                shape: BoxShape.circle,
              ),
              margin: const EdgeInsets.only(right: 25),
              child: IconButton(onPressed: sendMessage, icon: Icon(Icons.arrow_upward)))
        ],
      ),
    );
  }
}



