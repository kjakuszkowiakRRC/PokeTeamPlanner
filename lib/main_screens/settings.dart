import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:poke_team_planner/universal/account_alert.dart';
import 'package:poke_team_planner/universal/poke_app_bar.dart';
import 'package:theme_provider/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          actions: [
            AccountAlert(),
          ],
          // leading: IconButton(
          //     icon: Icon(Icons.arrow_back),
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => Menu()),
          //       );
          //     }),
        ),
        body: SettingsGroup(
          title: 'App Settings',
          children: <Widget>[
            // CheckboxSettingsTile(
            //   settingKey: 'key-day-light-savings',
            //   title: 'Daylight Time Saving',
            //   enabledLabel: 'Enabled',
            //   disabledLabel: 'Disabled',
            //   leading: Icon(Icons.timelapse),
            // ),
            SwitchSettingsTile(
              settingKey: 'key-dark-mode',
              title: 'Dark Mode',
              enabledLabel: 'Enabled',
              disabledLabel: 'Disabled',
              leading: Icon(Icons.visibility_outlined),
              onChange: (value) {
                // EasyDynamicTheme.of(context).changeTheme();
                // _saveTheme(value);
                ThemeProvider.controllerOf(context).nextTheme();
              },
            ),
          ],
        ),
      );
  }
}
