import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:poke_team_planner/universal/poke_app_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      SettingsGroup(
        title: 'Group title',
        children: <Widget>[
          CheckboxSettingsTile(
            settingKey: 'key-day-light-savings',
            title: 'Daylight Time Saving',
            enabledLabel: 'Enabled',
            disabledLabel: 'Disabled',
            leading: Icon(Icons.timelapse),
          ),
          SwitchSettingsTile(
            settingKey: 'key-dark-mode',
            title: 'Dark Mode',
            enabledLabel: 'Enabled',
            disabledLabel: 'Disabled',
            leading: Icon(Icons.palette),
          ),
        ],
      );
  }
}
