import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:poke_team_planner/universal/poke_app_bar.dart';
import 'package:poke_team_planner/universal/pokemon_type_row.dart';
import 'package:poke_team_planner/utils/pokemon.dart';
import 'package:poke_team_planner/utils/string_extension.dart';
import 'package:http/http.dart' as http;

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

  static void preload(BuildContext context, String path) {
    var configuration = createLocalImageConfiguration(context);
    new NetworkImage(path)..resolve(configuration);
  }

  @override
  Widget build(BuildContext context) {
    preload(context, widget.pokemonObject.shinySpriteURL);
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
              PokemonTypeRow(widget.pokemonObject.typesImageURL),
              Text('Height: ${widget.pokemonObject.getHeight()}'),
              Text('Weight: ${widget.pokemonObject.getWeight()}'),
              // PokemonTypeRow(widget.pokemonObject.typesImageURL),
              _buildAbilityRow(context, widget.pokemonObject.abilities),
              // Text('Types: ${widget.pokemonObject.getListContents(widget.pokemonObject.types)}'),
              // _buildTypeRow(context, widget.pokemonObject.typesImageURL),
              Text('Description: ${widget.pokemonObject.getPokedexEntry()}')
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAbilityRow(BuildContext context, List<Ability> abilities) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Abilities:"),
        ..._buildAbilityRowList(abilities),
    ],
    );
  }

  List<Widget> _buildAbilityRowList(List<Ability> abilityList) {
    List<Widget> abilities = [];
    for(Ability ability in abilityList) {
      TextButton abilityWidget = TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupDialog(context, ability),
          );
        },
        child: Text(
          ability.name.toTitleCase()
        )
      );
      abilities.add(abilityWidget);
    }
    return abilities;
  }

  AlertDialog _buildPopupDialog(BuildContext context, Ability ability) {
    return AlertDialog(
      title: Text(ability.name.toTitleCase()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(ability.description!),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildTypeRow(BuildContext context, List<String> types) {
    // print("_buildTypeRow: ");
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ..._buildTypeRowList(types),
      ],
    );
  }

  List<Widget> _buildTypeRowList(List<String> typeList) {
    List<Widget> abilities = [];
    for(String type in typeList) {
      // print("TEST: " + type);
      Image abilityWidget = Image(
        image: AssetImage(type),
        width: 100,
      );
      abilities.add(abilityWidget);
    }
    return abilities;
  }
}