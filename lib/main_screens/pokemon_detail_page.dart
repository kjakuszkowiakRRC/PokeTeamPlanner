import 'package:flutter/material.dart';
import 'package:poke_team_planner/universal/poke_app_bar.dart';
import 'package:poke_team_planner/utils/string_extension.dart';

//TODO: do api call here for details after passing pokemon object
//TODO: add event so when tapping on ability it shows popup of explanation
class PokemonDetailPage extends StatefulWidget {
  var pokemonObject;
  PokemonDetailPage({
    this.pokemonObject
  });

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  bool isSwitched = false;
  String pokemonURL = "";

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
              Text(widget.pokemonObject.name.toString().toTitleCase()),
              Image.network(pokemonURL.isEmpty ? widget.pokemonObject.spriteURL : pokemonURL),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Shiny Model Slider'),
                  // Image.network(widget.pokemonObject.shinySpriteURL),
                  Switch(
                      value: isSwitched,

                      onChanged: (value) {
                        setState(() {
                          if(!value) {
                            pokemonURL = widget.pokemonObject.spriteURL;
                          }
                          else {
                            pokemonURL = widget.pokemonObject.shinySpriteURL;
                          }
                          isSwitched = value;
                        });
                      })
                ],
              ),
              Text('Height: ${widget.pokemonObject.getHeight()}'),
              Text('Weight: ${widget.pokemonObject.getWeight()}'),
              Text('Abilities: ${widget.pokemonObject.getListContents(widget.pokemonObject.abilities)}'),
              Text('Types: ${widget.pokemonObject.getListContents(widget.pokemonObject.types)}'),
              Text('Description: ${widget.pokemonObject.getPokedexEntry()}')
            ],
          ),
        ),
      ),
    );
  }
}