import 'package:flutter/material.dart';
import 'package:poke_team_planner/main_screens/poke_teams.dart';
import 'package:poke_team_planner/main_screens/pokedex.dart';
import 'package:poke_team_planner/universal/account_alert.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Poke Team Builder'),
        actions: <Widget>[
          AccountAlert(),
          // IconButton(
          //   icon: const Icon(Icons.account_box),
          //   tooltip: 'Show Snackbar',
          //   onPressed: () {
          //     // ScaffoldMessenger.of(context).showSnackBar(
          //     //     const SnackBar(content: Text('This is a snackbar')));
          //     AccountAlert();
          //   },
          // ),
          IconButton(
            icon: const Icon(Icons.workspaces_filled),
            tooltip: 'Go to the next page',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Next page'),
                    ),
                    body: const Center(
                      child: Text(
                        'This is the next page',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ));
            },
          ),
        ],
      ),
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
              )
            ],
          ),
    );
  }
}
