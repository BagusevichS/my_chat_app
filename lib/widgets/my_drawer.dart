import 'package:flutter/material.dart';
import 'package:my_chat_app/UI/pages/settings_page.dart';
import '../domain/services/auth_service.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  void logout(){
    final authService = AuthService();
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                  child: Icon(
                Icons.message,
                color: Theme.of(context).colorScheme.surface,
                size: 40,
              )
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: Text("Д О М О Й",style: TextStyle(color: Theme.of(context).colorScheme.surface),),
                  leading: Icon(Icons.home,color: Theme.of(context).colorScheme.surface,),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ListTile(
                  title: Text("Н А С Т Р О Й К И",style: TextStyle(color: Theme.of(context).colorScheme.surface),),
                  leading: Icon(Icons.settings,color: Theme.of(context).colorScheme.surface,),
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                        )
                    );
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: ListTile(
              title: Text("В Ы Й Т И",style: TextStyle(
                color: Theme.of(context).colorScheme.surface
              ),),
              leading: Icon(Icons.logout,color: Theme.of(context).colorScheme.surface,),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}
