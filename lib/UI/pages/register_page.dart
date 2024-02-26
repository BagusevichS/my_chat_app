import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/domain/services/auth_service.dart';
import 'package:my_chat_app/themes/theme_provider.dart';
import 'package:my_chat_app/widgets/my_button.dart';
import 'package:my_chat_app/widgets/my_text_field.dart';
import 'package:provider/provider.dart';



class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final void Function()? onTap;
  RegisterPage({Key? key, this.onTap}) : super(key: key);

  void register(BuildContext context) async {
    final auth = AuthService();

    if (_passwController.text == _confirmController.text) {
      try {
        await auth.signUpWithEmailPassword(_emailController.text, _passwController.text);
      } catch (e) {
        String errorMessage = 'Произошла ошибка во время регистрации';
        // Обрабатываем различные типы исключений
        if (e is FirebaseAuthException) {
          if (e.code == 'weak-password') {
            errorMessage = 'Пароль должен содержать не менее 6 символов';
          } else if (e.code == 'email-already-in-use') {
            errorMessage = 'Этот адрес электронной почты уже используется другим аккаунтом';
          } else {

          }
        }

        showDialog(
          context: context,
          builder: (context) => AlertDialog(

            title: Text(errorMessage,style: TextStyle(color: Color(0xFF81A7CC))),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog.adaptive(
          title: Text("Пароли не совпадают.", style: TextStyle(color: Color(0xFF81A7CC))),
        ),
      );
    }
  }



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
              "Давай скорее зарегистрируемся!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20,),
            MyTextField(hintText: "Электронная почта", obscureText: false, controller: _emailController,),
            const SizedBox(height: 5,),
            MyTextField(hintText: "Пароль", obscureText: true, controller: _passwController,),
            const SizedBox(height: 5,),
            MyTextField(hintText: "Подтвердить пароль", obscureText: true, controller: _confirmController,),
            const SizedBox(height: 25,),
            MyButton(text: "Зарегистрироваться", onTap: ()=> register(context),),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Есть аккаунт?"),
                TextButton(
                    onPressed: onTap,
                    child: Text(
                      "Войти.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode? Colors.white:Colors.grey.shade900,
                      ),
                    )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
