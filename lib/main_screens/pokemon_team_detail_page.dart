import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:poke_team_planner/main_screens/poke_teams.dart';
import 'package:poke_team_planner/universal/poke_app_bar.dart';
import 'package:poke_team_planner/universal/pokemon_type_row.dart';
import 'package:poke_team_planner/utils/pokemon.dart';
import 'package:poke_team_planner/utils/pokemon_team.dart';
import 'package:poke_team_planner/utils/string_extension.dart';
import 'package:http/http.dart' as http;

//TODO: add listview/cards for pokemon
//TODO: add delete team button
//TODO: add edit team button?? maybe just quick remove pokemon and add new ones in or something

class PokemonTeamDetailPage extends StatefulWidget {
  var pokemonTeamObject;
  PokemonTeamDetailPage({
    this.pokemonTeamObject
  });

  @override
  State<PokemonTeamDetailPage> createState() => _PokemonTeamDetailPageState();
}

class _PokemonTeamDetailPageState extends State<PokemonTeamDetailPage> {
  bool isSwitched = false;
  String pokemonURL = "";

  static void preload(BuildContext context, String path) {
    var configuration = createLocalImageConfiguration(context);
    new NetworkImage(path)..resolve(configuration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PokeAppBar(),
      body: Column(
        children: [
          Text(widget.pokemonTeamObject.name.toString().toTitleCase()),
          TextButton(
              onPressed: () {
                deletePokemonTeam(widget.pokemonTeamObject);
              },
              child: Text("Delete team"))
        ],
      ) ,
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
      Image abilityWidget = Image(
        image: AssetImage(type),
        width: 100,
      );
      abilities.add(abilityWidget);
    }
    return abilities;
  }

  void deletePokemonTeam(pokemonTeamObject) {
    pokemonTeamObject.delete();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PokeTeams()),
    );
  }
}