import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poke_team_planner/main_screens/poke_teams.dart';
import 'package:poke_team_planner/main_screens/pokedex.dart';
import 'package:poke_team_planner/main_screens/pokedex2.dart';
import 'package:poke_team_planner/main_screens/settings.dart';
import 'package:poke_team_planner/universal/account_alert.dart';
import 'package:poke_team_planner/universal/poke_app_bar.dart';
import 'package:poke_team_planner/user_screens/login_page.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

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
      body: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                // icon: Image.asset('assets/images/pokeball.png'),
                  icon: Image(
                    image: AssetImage('assets/images/pokeball.png'),
                    width: 75,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Pokedex()),
                    );
                  },
                  label: const Text(
                    'Go to Pokedex',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                    ),
                  )
              ),
              TextButton.icon(
                  icon: Image(
                    image: AssetImage('assets/images/poke_team.png'),
                    width: 75,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const PokeTeams()),
                    );
                  },
                  label: const Text(
                    'Go to your teams',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                    ),
                  )
              ),
              TextButton.icon(
                // icon: Image.asset('assets/images/pokeball.png'),
                  icon: Image(
                    image: AssetImage('assets/images/pokeball.png'),
                    width: 75,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Pokedex2()),
                    );
                  },
                  label: const Text(
                    'Go to Pokedex TESTER',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                    ),
                  )
              ),
            ],
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
