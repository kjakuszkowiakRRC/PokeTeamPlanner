import 'package:flutter/material.dart';
import 'package:poke_team_planner/universal/poke_app_bar.dart';

//TODO: do api call here for details after passing pokemon object
//TODO: shiny sprite??
class PokemonDetailPage extends StatefulWidget {
  var pokemonObject;
  PokemonDetailPage({
    this.pokemonObject
  });

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
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
              Text(widget.pokemonObject.name)
            ],
          ),
        ),
      ),
    );
  }
}