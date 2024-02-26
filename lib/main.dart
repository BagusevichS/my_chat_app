import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_chat_app/themes/light_mode.dart';
import 'package:my_chat_app/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'UI/pages/auth_gate.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp( options: FirebaseOptions(
      apiKey: 'AIzaSyDbKiTKU6HSEwk7ijEQ3qhLSm4HrW_cS48',
      appId:'1:921029919071:android:97dc25f1ff4afdecc636ea',
      messagingSenderId: '921029919071',
      projectId: 'mychat-248c2')
  );
  runApp(ChangeNotifierProvider(
    create: (context)=> ThemeProvider(),
    child: const MyApp(),
  )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: AuthGate(),
    );
  }
}
