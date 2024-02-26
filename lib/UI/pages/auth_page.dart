import 'package:flutter/material.dart';
import 'package:my_chat_app/themes/theme_provider.dart';
import 'package:my_chat_app/widgets/my_button.dart';
import 'package:my_chat_app/widgets/my_text_field.dart';
import 'package:provider/provider.dart';

import '../../domain/services/auth_service.dart';
import '../../domain/functions.dart';

class AuthPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwController = TextEditingController();
  final void Function()? onTap;

  AuthPage({Key? key, this.onTap}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context,listen: false).isDarkMode;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 50,),
            Text(
              "С возвращением! Мы скучали!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20,),
            MyTextField(hintText: "Электронная почта", obscureText: false, controller: _emailController,),
            const SizedBox(height: 5,),
            MyTextField(hintText: "Пароль", obscureText: true, controller: _passwController,),
            const SizedBox(height: 25,),
            MyButton(text: "Войти", onTap:() => login(context,_emailController,_passwController),),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Нет аккаунта?"),
                  TextButton(
                      onPressed:onTap,
                      child: Text(
                        "Зарегистрироваться.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode? Colors.white:Colors.grey.shade900,
                        ),
                      )
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
