import 'package:flutter/material.dart';
import 'package:poke_team_planner/universal/poke_app_bar.dart';

//TODO: use https://pokeapi.co/api/v2//type/12/ for damage calculations

class PokeTeams extends StatelessWidget {
  const PokeTeams({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PokeAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            ],
          ),
        ),
      ),
    );
  }
}
