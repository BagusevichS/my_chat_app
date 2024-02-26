import 'package:flutter/material.dart';

import 'services/auth_service.dart';

void login(BuildContext context, TextEditingController emailController,TextEditingController passwController) async {
  final authService = AuthService();
  try{
    await authService.signInWithEmailPassword
      (emailController.text,
        passwController.text
    );
  }
  catch(e){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        )
    );
  }
}

void scrollDown(ScrollController scrollController){
  scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn);
}

