import 'package:flutter/material.dart';
import 'package:poke_team_planner/main_screens/pokedex.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Poke Team Builder'),
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
                      MaterialPageRoute(builder: (context) => Pokedex()),
                    );
                  },
                  label: const Text(
                    'Go to Pokedex',
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
