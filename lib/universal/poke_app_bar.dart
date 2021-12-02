import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poke_team_planner/main_screens/settings.dart';
import 'package:poke_team_planner/user_screens/login_page.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import 'account_alert.dart';

class PokeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PokeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Poke Team Builder'),
      actions: <Widget>[
        AccountAlert(),
        PopupMenuButton<String>(
          // onSelected: handleClick(),
          onSelected: (result) async {
            switch (result) {
              case 'Settings':
                // await Settings.init();
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(
                //     builder: (context) => SettingsPage(),
                //   ),
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                  ),
                );
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context) => const SettingsPage()),
                    // );
                // );
                break;
              case 'Logout':
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            return {'Settings','Logout'}.map((String choice) {
              return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice)
              );
            }).toList();
          },
        ),
      ],
    );
  }
  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
