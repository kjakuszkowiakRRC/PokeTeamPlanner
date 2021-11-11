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
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: Image.asset('assets/images/pokeball.png'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Pokedex()),
                    );
                  },
                  label: Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
