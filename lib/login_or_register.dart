import 'package:flutter/material.dart';
import 'package:my_chat_app/register_page.dart';
import 'auth_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({Key? key}) : super(key: key);

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {

  bool showLoginPage = true;

  void switchPages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return AuthPage(onTap: switchPages,);
    } else {
      return RegisterPage(onTap: switchPages,);
    }
  }
}
