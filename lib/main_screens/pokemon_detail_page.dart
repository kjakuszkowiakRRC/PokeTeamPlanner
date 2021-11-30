import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:poke_team_planner/universal/poke_app_bar.dart';
import 'package:poke_team_planner/universal/pokemon_type_row.dart';
import 'package:poke_team_planner/utils/boxes.dart';
import 'package:poke_team_planner/utils/pokemon.dart';
import 'package:poke_team_planner/utils/pokemon_team.dart';
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
  String dropdownValue = 'Pick a team';

  var box = Hive.box<PokemonTeam>('pokemon_teams');
  // late PokemonTeam? selectedPokemonTeam;
  //some sort of add team thing

  static void preload(BuildContext context, String path) {
    var configuration = createLocalImageConfiguration(context);
    new NetworkImage(path)..resolve(configuration);
  }

  // @override
  // void initState() {
  //   _loadBoxes();
  //   selectedPokemonTeam = box.getAt(0);
  //   super.initState();
  // }

  // Future _loadBoxes() async {
  //   await Hive.openBox<PokemonTeam>('pokemon_teams');
  // }

  @override
  Widget build(BuildContext context) {
    preload(context, widget.pokemonObject.shinySpriteURL);
    return Scaffold(
      appBar: PokeAppBar(),
      body: ValueListenableBuilder<Box<PokemonTeam>>(
        valueListenable: Boxes.getPokemonTeams().listenable(),
        builder: (context, box, _) {
          final pokemonTeams = box.values.toList().cast<PokemonTeam>().where((element) => element.userID == FirebaseAuth.instance.currentUser?.uid).toList();
          return buildContent(pokemonTeams);
        },
      ),

    );
  }

  Widget buildContent(List<PokemonTeam> pokemonTeams) {
    if (pokemonTeams.isNotEmpty) {
      // print(pokemonTeams.first);
      List<String> list = [];
      pokemonTeams.forEach((element) => list.add(element.name));

      PokemonTeam selectedPokemonTeam = pokemonTeams.first;
      // print(list.first);
      return Padding(
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
              Text('Description: ${widget.pokemonObject.getPokedexEntry()}'),
              Row(
                children: [
                  DropdownButton<PokemonTeam>(
                    value: selectedPokemonTeam,
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (PokemonTeam? newValue) {
                      setState(() {
                        selectedPokemonTeam = newValue!;
                        print("onchanged: "+selectedPokemonTeam.key.toString());
                      });
                    },
                    // items: pokemonT
                    items: pokemonTeams
                        .map((PokemonTeam pokemonTeam) {
                      return DropdownMenuItem<PokemonTeam>(
                        value: pokemonTeam,
                        child: Text(pokemonTeam.name),
                      );
                    }).toList(),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (selectedPokemonTeam.pokemonTeam.length < 6) {
                          selectedPokemonTeam.pokemonTeam.add(widget.pokemonObject);
                          if (selectedPokemonTeam.pokemonTeamTypes.isEmpty) {
                            for(var type in widget.pokemonObject.types) {
                              print("NONE");
                              selectedPokemonTeam.pokemonTeamTypes.add(type.name);
                            }
                          }
                          else {
                            List tempList = [];
                            for(var typeTop in widget.pokemonObject.types) {
                              // var contain = listOfDownloadedFile.where((element) => element.Url == "your URL link")
                              // print("FIRST LEVEL: "+typeTop.name);
                              // // for(var type in widget.pokemonObject.types) {
                              //   print("SECOND LEVEL: "+type.name);
                                if(!selectedPokemonTeam.pokemonTeamTypes.contains(typeTop.name)) {
                                  print("DEEP INSIDE " + typeTop.name);
                                  tempList.add(typeTop.name);
                                }
                              // }

                            }
                            selectedPokemonTeam.pokemonTeamTypes.addAll(tempList);
                            tempList = [];
                          }
                          // for(var typeTop in selectedPokemonTeam.pokemonTeamTypes) {
                          //
                          //   for(var type in widget.pokemonObject.types) {
                          //     if(!typeTop.name.toString().contains(type.name.toString())) {
                          //       print("inside");
                          //       selectedPokemonTeam.pokemonTeamTypes.add(type.name);
                          //     }
                          //   }
                          //
                          // }
                          // for(var type in widget.pokemonObject.types) {
                          //   print('Type: ${type.name} inside? ${selectedPokemonTeam.pokemonTeamTypes.contains(type)}');
                          //   if (!selectedPokemonTeam.pokemonTeamTypes.contains(type.name.toString())) {
                          //     print("inside");
                          //     selectedPokemonTeam.pokemonTeamTypes.add(type);
                          //   }
                          // }
                          final snackBar = SnackBar(content: Text('Added: ${widget.pokemonObject.name.toString().toTitleCase()} to ${selectedPokemonTeam.name}'));

                          // Find the ScaffoldMessenger in the widget tree
                          // and use it to show a SnackBar.
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        else {
                          final snackBar = SnackBar(content: Text('You have reached the maximum number of pokemon in ${selectedPokemonTeam.name}. Remove one before adding another.'));

                          // Find the ScaffoldMessenger in the widget tree
                          // and use it to show a SnackBar.
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }

                      },
                      child: Text("Add to team"))
                ],
              )
            ],
          ),
        ),
      );
    } else {


      return Column(
        children: [
          SizedBox(height: 24),
          Text(
            'Pokemon Teams: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 24),
          // Expanded(
          //   child: ListView.builder(
          //     padding: EdgeInsets.all(8),
          //     itemCount: pokemonTeams.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       final pokemonTeam = pokemonTeams[index];
          //
          //       // return buildTeam(context, pokemonTeam);
          //     },
          //   ),
          // ),
        ],
      );
    }
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