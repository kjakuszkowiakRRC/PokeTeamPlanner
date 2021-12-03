import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:poke_team_planner/main_screens/poke_teams.dart';
import 'package:poke_team_planner/main_screens/pokedex3.dart';
import 'package:poke_team_planner/main_screens/pokedex.dart';
import 'package:poke_team_planner/main_screens/settings.dart';
import 'package:poke_team_planner/universal/account_alert.dart';
import 'package:poke_team_planner/universal/poke_app_bar.dart';
import 'package:poke_team_planner/user_screens/login_page.dart';
import 'package:poke_team_planner/user_screens/profile_page.dart';

class Menu extends StatelessWidget {
  Menu({Key? key}) : super(key: key);
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PokeAppBar(),
      // appBar: AppBar(
      //   title: Text('Poke Team Builder'),
      //   actions: <Widget>[
      //     AccountAlert(),
      //     PopupMenuButton<String>(
      //       // onSelected: handleClick(),
      //       onSelected: (result) async {
      //         switch (result) {
      //           case 'Settings':
      //             Navigator.of(context).pushReplacement(
      //                 MaterialPageRoute(
      //                   builder: (context) => Settings(),
      //                 ),
      //             );
      //             break;
      //           case 'Logout':
      //             await FirebaseAuth.instance.signOut();
      //             Navigator.of(context).pushReplacement(
      //               MaterialPageRoute(
      //                 builder: (context) => LoginPage(),
      //               ),
      //             );
      //             break;
      //         }
      //       },
      //       itemBuilder: (BuildContext context) {
      //         return {'Settings','Logout'}.map((String choice) {
      //           return PopupMenuItem<String>(
      //             value: choice,
      //             child: Text(choice)
      //           );
      //         }).toList();
      //       },
      //     ),
      //   ],
      // ),
      body: Center(
        // padding: const EdgeInsets.all(25.0),
        child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    primary: Colors.red.withOpacity(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(2),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Pokedex()),
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      Image(
                        image: AssetImage('assets/images/pokeball.png'),
                        width: 75,
                      ), // icon
                      Text(
                        'Pokedex',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 30,
                        ),
                      ), // text
                    ],
                  ),
                ),
                SizedBox(height: 30),
                // SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    primary: Colors.red.withOpacity(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(2),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const PokeTeams()),
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      Image(
                        image: AssetImage('assets/images/poke_team.png'),
                        width: 75,
                      ), // icon
                      Text(
                        'Team Builder',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 30,
                        ),
                      ), // text
                    ],
                  ),
                ),
                SizedBox(height: 30),
                // SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    primary: Colors.red.withOpacity(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(2),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProfilePage(
                        user: user!,
                      )),
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      Image(
                        image: AssetImage('assets/images/account.png'),
                        width: 75,
                      ), // icon
                      Text(
                        'Account',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 30,
                        ),
                      ), // text
                    ],
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    primary: Colors.red.withOpacity(0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(2),
                        ),
                        ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ),
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      Image(
                        image: AssetImage('assets/images/settings.png'),
                        width: 75,
                      ), // icon
                      Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 30,
                        ),
                      ), // text
                    ],
                  ),
                ),
                // TextButton.icon(
                //   // icon: Image.asset('assets/images/pokeball.png'),
                //     icon: Image(
                //       image: AssetImage('assets/images/poke_team.png'),
                //       width: 75,
                //     ),
                //     onPressed: () {
                //       Navigator.of(context).push(
                //         MaterialPageRoute(builder: (context) => const PokeTeams()),
                //       );
                //     },
                //     label: const Text(
                //       'Pokedex',
                //       style: TextStyle(
                //         color: Colors.black,
                //         fontSize: 30,
                //       ),
                //     )
                // ),
                // TextButton.icon(
                //   // icon: Image.asset('assets/images/pokeball.png'),
                //     icon: Image(
                //       image: AssetImage('assets/images/pokeball.png'),
                //       width: 75,
                //     ),
                //     onPressed: () {
                //       Navigator.of(context).push(
                //         MaterialPageRoute(builder: (context) => const Pokedex()),
                //       );
                //     },
                //     label: const Text(
                //       'Pokedex',
                //       style: TextStyle(
                //         color: Colors.black,
                //         fontSize: 30,
                //       ),
                //     )
                // ),
                // TextButton.icon(
                //     icon: Image(
                //       image: AssetImage('assets/images/poke_team.png'),
                //       width: 75,
                //     ),
                //     onPressed: () {
                //       Navigator.of(context).push(
                //         MaterialPageRoute(builder: (context) => const PokeTeams()),
                //       );
                //     },
                //     label: const Text(
                //       'Team Builder',
                //       style: TextStyle(
                //         color: Colors.black,
                //         fontSize: 30,
                //       ),
                //     )
                // ),
                // TextButton.icon(
                //   // icon: Image.asset('assets/images/pokeball.png'),
                //     icon: Image(
                //       image: AssetImage('assets/images/pokeball.png'),
                //       width: 75,
                //     ),
                //     onPressed: () {
                //       Navigator.of(context).push(
                //         MaterialPageRoute(builder: (context) => const Pokedex()),
                //       );
                //     },
                //     label: const Text(
                //       'Go to Pokedex TESTER',
                //       style: TextStyle(
                //         color: Colors.black,
                //         fontSize: 30,
                //       ),
                //     )
                // ),
              ],
            ),
      ),
    );
  }
}

// Future<void> handleClick(BuildContext context, String value) async {
//   switch (value) {
//     case 'Settings':
//       break;
//     case 'Logout':
//       await FirebaseAuth.instance.signOut();
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (context) => LoginPage(),
//         ),
//       );
//       break;
//   }
// }
