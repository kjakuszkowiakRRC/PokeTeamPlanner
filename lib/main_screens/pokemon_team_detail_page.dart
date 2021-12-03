import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:poke_team_planner/main_screens/poke_teams.dart';
import 'package:poke_team_planner/universal/poke_app_bar.dart';
import 'package:poke_team_planner/universal/pokemon_type_row.dart';
import 'package:poke_team_planner/utils/pokedex_entry.dart';
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
  List<String> pokemonTypeListRefined = [];
  late List pokemonTypeList;
  late Future loadJsonData;

  // static void preload(BuildContext context, String path) {
  //   var configuration = createLocalImageConfiguration(context);
  //   new NetworkImage(path)..resolve(configuration);
  // }

  @override
  void initState() {
    loadJsonData = _loadJsonData();
    super.initState();
    // print("LOAD");
    // loadJsonData();
    // print("FULLY LOADED");
  }



  Future<String> _loadJsonData() async {
    var jsonText = await rootBundle.loadString('assets/types.json');
    // print(jsonText);
    setState(() => pokemonTypeList = json.decode(jsonText));
    return 'success';
  }

  @override
  Widget build(BuildContext context) {
    // preload(context, widget.pokemonTeamObject.shinySpriteURL);
    return Scaffold(
      appBar: PokeAppBar(),
      body: Column(
        children: [
          // Text(widget.pokemonTeamObject.name.toString().toTitleCase()),
          SizedBox(height: 5),
          RichText(
              text: new TextSpan(
                // Note: Styles for TextSpans must be explicitly defined.
                // Child text spans will inherit styles from parent
                style: new TextStyle(
                  fontSize: 30.0,
                ),
                children: <TextSpan>[
                  new TextSpan(text: widget.pokemonTeamObject.name.toString().toTitleCase(), style: new TextStyle(fontWeight: FontWeight.bold)),
                ]
                ,
              )
          ),
          SizedBox(height: 5),
          // Text('Team Size: ' + widget.pokemonTeamObject.length.toString()),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.pokemonTeamObject.pokemonTeam.length,
                  itemBuilder: (context, position) {
                    widget.pokemonTeamObject.pokemonTeam.elementAt(position);
                    return _buildPokeTeamRow(position);
                  },
                ),
              ],
            ),
          ),
          ElevatedButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Team Breakdown'),
                      content: SingleChildScrollView(
                        child: TypeTable(pokemonTeam: widget.pokemonTeamObject),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );

              },
              child: Text("Check your team compatibility")),


          SizedBox(height: 5),
          // Expanded(
          //   child: FutureBuilder(
          //     future: loadJsonData,
          //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          //       print(widget.pokemonTeamObject.pokemonTeam.isEmpty);
          //       if(widget.pokemonTeamObject.pokemonTeam.isNotEmpty) {
          //         return TypeTable(pokemonTeam: widget.pokemonTeamObject);
          //       }
          //       return SizedBox.shrink();
          //
          //       // return Text("HELLO");
          //       // return ListView(
          //       //     shrinkWrap: true,
          //       //     children: [
          //       //       ListView.builder(
          //       //         shrinkWrap: true,
          //       //
          //       //         physics: NeverScrollableScrollPhysics(),
          //       //         itemCount: widget.pokemonTeamObject.pokemonTeamTypes.length,
          //       //         itemBuilder: (context, position) {
          //       //           print(pokemonTypeList);
          //       //           // widget.pokemonTeamObject.pokemonTeamTypes.elementAt(position);
          //       //           if(!pokemonTypeListRefined.contains(widget.pokemonTeamObject.pokemonTeamTypes.elementAt(position))) {
          //       //             pokemonTypeListRefined.add(widget.pokemonTeamObject.pokemonTeamTypes.elementAt(position));
          //       //             // return Text(widget.pokemonTeamObject.pokemonTeamTypes.elementAt(position));
          //       //
          //       //             for (var type in pokemonTypeList){
          //       //               if(type['name'] == widget.pokemonTeamObject.pokemonTeamTypes.elementAt(position)) {
          //       //                 // pokemon.typesImageURL!.add(type['image_path']);
          //       //                 print(type['image_path']);
          //       //                 return Image(
          //       //                   image: AssetImage(type['image_path']),
          //       //                   width: 100,
          //       //                 );
          //       //               }
          //       //
          //       //               // print(firstMap[key]);
          //       //             }
          //       //
          //       //           }
          //       //           return SizedBox.shrink();
          //       //         },
          //       //       ),
          //       //     ],
          //       //   // ),
          //       // );
          //     },
          //
          //   ),
          // ),
          // TextButton(
          //     onPressed: () {
          //       deletePokemonTeam(widget.pokemonTeamObject);
          //       // Navigator.pushAndRemoveUntil<dynamic>(
          //       //   context,
          //       //   MaterialPageRoute<dynamic>(
          //       //     builder: (BuildContext context) => YourPageNameGoesHere(),
          //       //   ),
          //       //       (route) => false,//if you want to disable back feature set to false
          //       // );
          //       Navigator.pop(context);
          //       // Navigator.of(context).push(
          //       //   MaterialPageRoute(builder: (context) => const PokeTeams()),
          //       // );
          //     },
          //     child: Text("Delete team"))
        ],
      ) ,
      // body: Padding(
      //   padding: const EdgeInsets.all(30.0),
      //   child: Center(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Text(widget.pokemonObject.name.toString().toTitleCase()),
      //         Image.network(pokemonURL.isEmpty ? widget.pokemonObject.spriteURL : pokemonURL),
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Text('Shiny Model Slider'),
      //             Switch(
      //                 value: isSwitched,
      //                 onChanged: (value) {
      //                   setState(() {
      //                     if(!value) {
      //                       pokemonURL = widget.pokemonObject.spriteURL;
      //                     }
      //                     else {
      //                       pokemonURL = widget.pokemonObject.shinySpriteURL;
      //                     }
      //                     isSwitched = value;
      //                   });
      //                 })
      //           ],
      //         ),
      //         PokemonTypeRow(widget.pokemonObject.typesImageURL),
      //         Text('Height: ${widget.pokemonObject.getHeight()}'),
      //         Text('Weight: ${widget.pokemonObject.getWeight()}'),
      //         // PokemonTypeRow(widget.pokemonObject.typesImageURL),
      //         _buildAbilityRow(context, widget.pokemonObject.abilities),
      //         // Text('Types: ${widget.pokemonObject.getListContents(widget.pokemonObject.types)}'),
      //         // _buildTypeRow(context, widget.pokemonObject.typesImageURL),
      //         Text('Description: ${widget.pokemonObject.getPokedexEntry()}')
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildPokeTeamRow(int position) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PokedexEntry(widget.pokemonTeamObject.pokemonTeam.elementAt(position), false),
        IconButton(
          icon: const Icon(Icons.clear),
          tooltip: 'Remove from team',
          onPressed: () {
            for(var type in widget.pokemonTeamObject.pokemonTeam.elementAt(position).types) {
              print(type.name);
              widget.pokemonTeamObject.pokemonTeamTypes.remove(type.name);
            }
            widget.pokemonTeamObject.pokemonTeam.removeAt(position);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => super.widget));
          // setState(() {
          //
          // });
          },
        )
        // ..._buildAbilityRowList(abilities),
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

  void deletePokemonTeam(pokemonTeamObject) {
    pokemonTeamObject.delete();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PokeTeams()),
    );
  }
}

class TypeTable extends StatefulWidget {
  var pokemonTeam;
  TypeTable({
    this.pokemonTeam
  });

  @override
  State<TypeTable> createState() => _TypeTableState();
}

class _TypeTableState extends State<TypeTable> {

  List typeAttackingStrengths = [];
  List typeAttackingWeaknesses = [];
  List typeAttackingNullified = [];
  List typeDefendingStrengths = [];
  List typeDefendingWeaknesses = [];
  List typeDefendingNullified = [];

  late Future loadTypeRelations;

  @override
  void initState() {
    loadTypeRelations = _loadTypeRelations();
    super.initState();
    // futurePokemon = fetchPokemon();
    // this.loadJsonData();
  }




  Future _loadTypeRelations() async {
    int endOfListCounter = 0;

    int alternateFormCounter = 0;
    // setState(() {
    //   isLoadingVertical = true;
    // });

    // Add in an artificial delay
    // await new Future.delayed(const Duration(seconds: 2));

    //put pokemon stuff under here

    List<Pokemon> pokemonListFiller = [];
    int listSize = 10;

    List<String> pokemonTypeListRefined = [];

    for(var pokemonType in widget.pokemonTeam.pokemonTeamTypes) {
      // print("TESTING: " + pokemonType);

      if(!pokemonTypeListRefined.contains(pokemonType)) {
        pokemonTypeListRefined.add(pokemonType);
        // return Text(widget.pokemonTeamObject.pokemonTeamTypes.elementAt(position));

        // print("TESTING: " + pokemonTypeListRefined.length);
        // for (var type in pokemonTypeList){
        //   if(type['name'] == widget.pokemonTeamObject.pokemonTeamTypes.elementAt(position)) {
        //     // pokemon.typesImageURL!.add(type['image_path']);
        //     print(type['image_path']);
        //     return Image(
        //       image: AssetImage(type['image_path']),
        //       width: 100,
        //     );
        //   }
        //
        //   // print(firstMap[key]);
        // }

      }
    }

    for(var pokemonType in pokemonTypeListRefined) {
      print("REFINED TESTING: " + pokemonType);

        final pokemonResponse = await http
            .get(Uri.parse('https://pokeapi.co/api/v2/type/${pokemonType}'));
        if (pokemonResponse.statusCode == 200) {
          Map typeInformation = jsonDecode(pokemonResponse.body);
          // print(typeInformation["damage_relations"]);
          List typeInformationItem = typeInformation["damage_relations"]["double_damage_from"];
          for(var type in typeInformationItem) {
            print(type["name"]);

            if(!typeDefendingWeaknesses.contains(type["name"])) {
              // print(type["name"]);
              typeDefendingWeaknesses.add(type["name"]);
            }
          }
          // print(typeInformation["damage_relations"]);
          typeInformationItem = typeInformation["damage_relations"]["double_damage_to"];
          for(var type in typeInformationItem) {
            print(type["name"]);

            if(!typeAttackingStrengths.contains(type["name"])) {
              // print(type["name"]);
              typeAttackingStrengths.add(type["name"]);
            }
          }
          // print(typeInformationItem);
          // print(typeInformation["damage_relations"]);
          typeInformationItem = typeInformation["damage_relations"]["half_damage_from"];
          for(var type in typeInformationItem) {
            print(type["name"]);

            if(!typeDefendingStrengths.contains(type["name"])) {
              // print(type["name"]);
              typeDefendingStrengths.add(type["name"]);
            }
          }
          // print(typeInformationItem);
          typeInformationItem = typeInformation["damage_relations"]["half_damage_to"];
          for(var type in typeInformationItem) {
            print(type["name"]);

            if(!typeAttackingWeaknesses.contains(type["name"])) {
              // print(type["name"]);
              typeAttackingWeaknesses.add(type["name"]);
            }
          }
          // print(typeInformationItem);
          typeInformationItem = typeInformation["damage_relations"]["no_damage_from"];
          for(var type in typeInformationItem) {
            print(type["name"]);

            if(!typeDefendingNullified.contains(type["name"])) {
              // print(type["name"]);
              typeDefendingNullified.add(type["name"]);
            }
          }
          // print(typeInformationItem);
          typeInformationItem = typeInformation["damage_relations"]["no_damage_to"];
          for(var type in typeInformationItem) {
            print(type["name"]);

            if(!typeAttackingNullified.contains(type["name"])) {
              // print(type["name"]);
              typeAttackingNullified.add(type["name"]);
            }
          }



        }

    }








    // // int listSize = 20;
    // // final snackBar = SnackBar(content: Text("HELLO"));
    // // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // for (var i = lazyListCounter;  !endOfList && i < lazyListCounter + 10; i++) {
    //   // print(pokemon.url);
    //   // print("BEFORE");
    //   final pokemonResponse = await http
    //       .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/${i + 1}'));
    //   // print("HELLO");
    //   if (pokemonResponse.statusCode == 200) {
    //     // print("MORE FIRST");
    //     Pokemon pokemon = new Pokemon.fromJson(
    //         jsonDecode(pokemonResponse.body));
    //
    //     String pokemonNameAltered = pokemon.name;
    //     if (pokemon.name.indexOf('-') > 0 && pokemon.name.substring(pokemon.name.indexOf('-'), pokemon.name.length).length > 3) {
    //       pokemonNameAltered = pokemon.name.substring(0, pokemon.name.indexOf('-'));
    //       alternateFormCounter++;
    //       if(alternateFormCounter == 2) {
    //         endOfList = true;
    //       }
    //     }
    //     // String pokemonNameAltered = pokemon.name.substring(0, pokemon.name.indexOf('-'));
    //     final pokedexEntryResponse = await http
    //         .get(Uri.parse(
    //         'https://pokeapi.co/api/v2/pokemon-species/${pokemonNameAltered}'));
    //
    //     if (pokedexEntryResponse.statusCode == 200) {
    //       Map firstMap = json.decode(pokedexEntryResponse.body);
    //       List jsonResponse = firstMap['flavor_text_entries'];
    //       for (var key in jsonResponse) {
    //         if (key['language']['name'] == 'en') {
    //           // print(pokemon.pokedexEntry);
    //           pokemon.pokedexEntry = key['flavor_text'];
    //         }
    //       }
    //
    //       // pokemon.pokedexEntry = jsonDecode(pokedexEntryResponse
    //       //   .body)['flavor_text_entries'][0]['flavor_text'];
    //     }
    //     else {
    //       throw Exception('Failed to load Pokedex entry');
    //     }
    //
    //
    //     for(var ability in pokemon.abilities) {
    //
    //       final response = await http
    //           .get(Uri.parse('https://pokeapi.co/api/v2/ability/${ability.name}'));
    //       Map firstMap = json.decode(response.body);
    //       List jsonResponse = firstMap['effect_entries'];
    //       for (var key in jsonResponse){
    //         if(key['language']['name'] == 'en') {
    //           ability.description = key['effect'];
    //         }
    //
    //       }
    //     }
    //
    //     pokemon.typesImageURL = [];
    //
    //     for (var pokemonType in pokemon.types) {
    //       for (var type in pokemonTypeList) {
    //         if (type['name'] == pokemonType.name) {
    //           pokemon.typesImageURL!.add(type['image_path']);
    //         }
    //       }
    //     }
    //     pokemonListFiller.add(pokemon);
    //     endOfListCounter++;
    //     // print("BIG LIST " + pokemonListFiller.elementAt(0).name + " | LENMGTGH: " + pokemonListFiller.length.toString());
    //
    //   }
    //   else {
    //     throw Exception('Failed to load Pokemon');
    //   }
    // }
    //
    // int incrementer = 10;
    // if(pokemonListFiller.length < 10) {
    //   incrementer = endOfListCounter-1;
    // }
    // if(pokemonListFiller.isNotEmpty) {
    //   basePokemonList.addAll(
    //       List.generate(
    //           incrementer, (index) => pokemonListFiller.elementAt(index)));
    //   viewPokemonList = basePokemonList;
    //   // print("BIG LIST " + pokemonList.last.name + " | LENMGTGH: " + pokemonList.length.toString());
    //   // }
    //   lazyListCounter += 10;
    // }

    // setState(() {
    //   isLoadingVertical = false;
    // });

  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadTypeRelations,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return SingleChildScrollView(
          child: Table(
              defaultColumnWidth: FixedColumnWidth(120.0),
              border: TableBorder.all(
                  color: Colors.black,
                  style: BorderStyle.solid,
                  width: 2),
              children: [
                TableRow( children: [
                  Column(children:[Text('', style: TextStyle(fontSize: 20.0))]),
                  Column(children:[Text('Types', style: TextStyle(fontSize: 20.0))]),
                ]),
                TableRow( children: [
                  Column(
                      children:[Text('Attacking - Strengths (2x Damage)',textAlign: TextAlign.center)]),
                  Column(
                      children:
                      typeAttackingStrengths.map((value) {
                        // print("TABLE CELL?? " + value);
                        return Text(value,);
                        //Return an empty Container for non-matching case
                      }).toList()),
                ]),
                TableRow( children: [
                  Column(children:[Text('Attacking - Weaknesses (0.5x Damage)',textAlign: TextAlign.center)]),
                  Column(
                      children:
                      typeAttackingWeaknesses.map((value) {
                        // print("TABLE CELL?? " + value);
                        return Text(value,);
                        //Return an empty Container for non-matching case
                      }).toList()),
                ]),
                TableRow( children: [
                  Column(children:[Text('Attacking - Not Effective (0x Damage)',textAlign: TextAlign.center)]),
                  Column(
                      children:
                      typeAttackingNullified.map((value) {
                        // print("TABLE CELL?? " + value);
                        return Text(value,);
                        //Return an empty Container for non-matching case
                      }).toList()),
                ]),
                TableRow( children: [
                  Column(children:[Text('Defending - Strengths (2x Damage)',textAlign: TextAlign.center)]),
                  Column(
                      children:
                      typeDefendingStrengths.map((value) {
                        // print("TABLE CELL?? " + value);
                        return Text(value,);
                        //Return an empty Container for non-matching case
                      }).toList()),
                ]),
                TableRow( children: [
                  Column(children:[Text('Defending - Weaknesses (0.5x Damage)',textAlign: TextAlign.center)]),
                  Column(
                      children:
                      typeDefendingWeaknesses.map((value) {
                        // print("TABLE CELL?? " + value);
                        return Text(value,);
                        //Return an empty Container for non-matching case
                      }).toList()),
                ]),
                TableRow( children: [
                  Column(children:[Text('Defending -  Not Effective (0x Damage)',textAlign: TextAlign.center)]),
                  Column(
                      children:
                      typeDefendingNullified.map((value) {
                        // print("TABLE CELL?? " + value);
                        return Text(value,);
                        //Return an empty Container for non-matching case
                      }).toList()),
                ]),
              ]
          ),
        );
      },

    );
    // , builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  },
    //   return Table(
    //     defaultColumnWidth: FixedColumnWidth(120.0),
    //       border: TableBorder.all(
    //           color: Colors.black,
    //           style: BorderStyle.solid,
    //           width: 2),
    //       children: [
    //   TableRow( children: [
    //       Column(children:[Text('Website', style: TextStyle(fontSize: 20.0))]),
    //       Column(children:[Text('Types', style: TextStyle(fontSize: 20.0))]),
    //     ]),
    //     TableRow( children: [
    //       Column(children:[Text('Attacking - Strengths (2x Damage)')]),
    //       Column(
    //           children:
    //             typeAttackingStrengths.map((value) {
    //               print("TABLE CELL?? " + value);
    //               return Text(value,);
    //               //Return an empty Container for non-matching case
    //             }).toList()),
    //     ]),
    //     TableRow( children: [
    //         Column(children:[Text('Attacking - Weaknesses (0.5x Damage)')]),
    //         Column(children:[Text('Flutter')]),
    //     ]),
    //     TableRow( children: [
    //         Column(children:[Text('Attacking - Not Effective (0x Damage)')]),
    //         Column(children:[Text('Flutter')]),
    //     ]),
    //     TableRow( children: [
    //       Column(children:[Text('Defending - Strengths (2x Damage)')]),
    //       Column(children:[Text('Flutter')]),
    //     ]),
    //     TableRow( children: [
    //       Column(children:[Text('Defending - Weaknesses (0.5x Damage)')]),
    //       Column(children:[Text('Flutter')]),
    //     ]),
    //     TableRow( children: [
    //       Column(children:[Text('Attacking - Weaknesses (0.5x Damage)')]),
    //       Column(children:[Text('Flutter')]),
    //     ]),
    //   ]
    // );
  }
}
// class _TypesTableState extends State<TypesTable> {
//
//   @override
//   void initState() {
//     _loadTypeRelations();
//     super.initState();
//     // futurePokemon = fetchPokemon();
//     // this.loadJsonData();
//   }
//
//
//
//   Future _loadTypeRelations() async {
//     int endOfListCounter = 0;
//
//     int alternateFormCounter = 0;
//     // setState(() {
//     //   isLoadingVertical = true;
//     // });
//
//     // Add in an artificial delay
//     // await new Future.delayed(const Duration(seconds: 2));
//
//     //put pokemon stuff under here
//
//     List<Pokemon> pokemonListFiller = [];
//     int listSize = 10;
//
//     List<String> pokemonTypeListRefined = [];
//
//     for(var pokemon in pokemonTeamTypes)
//       if(!pokemonTypeListRefined.contains(pokemonTeamTypes.pokemonTeamTypes.elementAt(position))) {
//         pokemonTypeListRefined.add(widget.pokemonTeamObject.pokemonTeamTypes.elementAt(position));
//         // return Text(widget.pokemonTeamObject.pokemonTeamTypes.elementAt(position));
//
//         for (var type in pokemonTypeList){
//           if(type['name'] == widget.pokemonTeamObject.pokemonTeamTypes.elementAt(position)) {
//             // pokemon.typesImageURL!.add(type['image_path']);
//             print(type['image_path']);
//             return Image(
//               image: AssetImage(type['image_path']),
//               width: 100,
//             );
//           }
//
//           // print(firstMap[key]);
//         }
//
//       }
//     // int listSize = 20;
//     // final snackBar = SnackBar(content: Text("HELLO"));
//     // ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     for (var i = lazyListCounter;  !endOfList && i < lazyListCounter + 10; i++) {
//       // print(pokemon.url);
//       // print("BEFORE");
//       final pokemonResponse = await http
//           .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/${i + 1}'));
//       // print("HELLO");
//       if (pokemonResponse.statusCode == 200) {
//         // print("MORE FIRST");
//         Pokemon pokemon = new Pokemon.fromJson(
//             jsonDecode(pokemonResponse.body));
//
//         String pokemonNameAltered = pokemon.name;
//         if (pokemon.name.indexOf('-') > 0 && pokemon.name.substring(pokemon.name.indexOf('-'), pokemon.name.length).length > 3) {
//           pokemonNameAltered = pokemon.name.substring(0, pokemon.name.indexOf('-'));
//           alternateFormCounter++;
//           if(alternateFormCounter == 2) {
//             endOfList = true;
//           }
//         }
//         // String pokemonNameAltered = pokemon.name.substring(0, pokemon.name.indexOf('-'));
//         final pokedexEntryResponse = await http
//             .get(Uri.parse(
//             'https://pokeapi.co/api/v2/pokemon-species/${pokemonNameAltered}'));
//
//         if (pokedexEntryResponse.statusCode == 200) {
//           Map firstMap = json.decode(pokedexEntryResponse.body);
//           List jsonResponse = firstMap['flavor_text_entries'];
//           for (var key in jsonResponse) {
//             if (key['language']['name'] == 'en') {
//               // print(pokemon.pokedexEntry);
//               pokemon.pokedexEntry = key['flavor_text'];
//             }
//           }
//
//           // pokemon.pokedexEntry = jsonDecode(pokedexEntryResponse
//           //   .body)['flavor_text_entries'][0]['flavor_text'];
//         }
//         else {
//           throw Exception('Failed to load Pokedex entry');
//         }
//
//
//         for(var ability in pokemon.abilities) {
//
//           final response = await http
//               .get(Uri.parse('https://pokeapi.co/api/v2/ability/${ability.name}'));
//           Map firstMap = json.decode(response.body);
//           List jsonResponse = firstMap['effect_entries'];
//           for (var key in jsonResponse){
//             if(key['language']['name'] == 'en') {
//               ability.description = key['effect'];
//             }
//
//           }
//         }
//
//         pokemon.typesImageURL = [];
//
//         for (var pokemonType in pokemon.types) {
//           for (var type in pokemonTypeList) {
//             if (type['name'] == pokemonType.name) {
//               pokemon.typesImageURL!.add(type['image_path']);
//             }
//           }
//         }
//         pokemonListFiller.add(pokemon);
//         endOfListCounter++;
//         // print("BIG LIST " + pokemonListFiller.elementAt(0).name + " | LENMGTGH: " + pokemonListFiller.length.toString());
//
//       }
//       else {
//         throw Exception('Failed to load Pokemon');
//       }
//     }
//
//     int incrementer = 10;
//     if(pokemonListFiller.length < 10) {
//       incrementer = endOfListCounter-1;
//     }
//     if(pokemonListFiller.isNotEmpty) {
//       basePokemonList.addAll(
//           List.generate(
//               incrementer, (index) => pokemonListFiller.elementAt(index)));
//       viewPokemonList = basePokemonList;
//       // print("BIG LIST " + pokemonList.last.name + " | LENMGTGH: " + pokemonList.length.toString());
//       // }
//       lazyListCounter += 10;
//     }
//
//     // setState(() {
//     //   isLoadingVertical = false;
//     // });
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Table(
//         defaultColumnWidth: FixedColumnWidth(120.0),
//         border: TableBorder.all(
//             color: Colors.black,
//             style: BorderStyle.solid,
//             width: 2),
//         children: [
//           TableRow( children: [
//             Column(children:[Text('', style: TextStyle(fontSize: 20.0))]),
//             Column(children:[Text('Types', style: TextStyle(fontSize: 20.0))]),
//           ]),
//           TableRow( children: [
//             Column(children:[Text('Attacking - Strengths (2x Damage)')]),
//             Column(children:[Text('Flutter')]),
//           ]),
//           TableRow( children: [
//             Column(children:[Text('Attacking - Weaknesses (0.5x Damage)')]),
//             Column(children:[Text('Flutter')]),
//           ]),
//           TableRow( children: [
//             Column(children:[Text('Attacking - Not Effective (0x Damage)')]),
//             Column(children:[Text('Flutter')]),
//           ]),
//           TableRow( children: [
//             Column(children:[Text('Defending - Strengths (2x Damage)')]),
//             Column(children:[Text('Flutter')]),
//           ]),
//           TableRow( children: [
//             Column(children:[Text('Defending - Weaknesses (0.5x Damage)')]),
//             Column(children:[Text('Flutter')]),
//           ]),
//           TableRow( children: [
//             Column(children:[Text('Defending - Not Effective (0x Damage)')]),
//             Column(children:[Text('Flutter')]),
//           ]),
//         ]
//
//     );
//   }