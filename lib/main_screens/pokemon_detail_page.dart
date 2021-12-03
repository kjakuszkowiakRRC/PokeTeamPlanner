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
  bool isFromPokedex;
  PokemonDetailPage({
    this.pokemonObject,
    required this.isFromPokedex
  });

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  bool isSwitched = false;
  String pokemonURL = "";
  String dropdownValue = 'Pick a team';
  late PokemonTeam selectedPokemonTeam;
  late Image spritePlaceholder;
  late Image sprite;
  late Image shinySprite;

  var box = Hive.box<PokemonTeam>('pokemon_teams');
  // late PokemonTeam? selectedPokemonTeam;
  //some sort of add team thing

  static void preload(BuildContext context, String path) {
    var configuration = createLocalImageConfiguration(context);
    new NetworkImage(path)..resolve(configuration);
  }

  @override
  void initState() {
    // adjust the provider based on the image type
    sprite = Image.network(widget.pokemonObject.spriteURL, scale: 0.5,);
    shinySprite = Image.network(widget.pokemonObject.shinySpriteURL, scale: 0.5,);
    spritePlaceholder = sprite;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(sprite.image, context);
    precacheImage(shinySprite.image, context);
  }
  // @override
  // void initState() {
  //   precacheImage(NetworkImage(widget.pokemonObject.shinySpriteURL), context);
  //   super.initState();
  // }

  // Future _loadBoxes() async {
  //   await Hive.openBox<PokemonTeam>('pokemon_teams');
  // }

  @override
  Widget build(BuildContext context) {
    preload(context, widget.pokemonObject.shinySpriteURL);
    didChangeDependencies();
    // spritePlaceholder = sprite;
    // precacheImage(NetworkImage(widget.pokemonObject.shinySpriteURL), context);
    // preload(context, widget.pokemonObject.spriteURL);
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
    // if (pokemonTeams.isNotEmpty) {
      // print(pokemonTeams.first);
      List<String> list = [];
      pokemonTeams.forEach((element) => list.add(element.name));

      // selectedPokemonTeam = ;
      // print(list.first);
      return Padding(
        padding: const EdgeInsets.only(left: 80.0, right: 25.0),
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Text(
                widget.pokemonObject.id.toString().padLeft(3, '0'),
                style:  TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 15),
              Text(
                widget.pokemonObject.name.toString().toTitleCase(),
                style:  TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              // SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: spritePlaceholder,
                // child: Image.network(
                //     pokemonURL.isEmpty ? widget.pokemonObject.spriteURL : pokemonURL,
                //   scale: .5,
                // ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Shiny Version'),
                    Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            if(!value) {
                              // pokemonURL = widget.pokemonObject.spriteURL;
                              spritePlaceholder = sprite;
                            }
                            else {
                              spritePlaceholder = shinySprite;
                              // pokemonURL = widget.pokemonObject.shinySpriteURL;
                            }
                            isSwitched = value;
                          });
                        })
                  ],
                ),
              ),
              PokemonTypeRow(widget.pokemonObject.typesImageURL, false),
              SizedBox(height: 25),
              RichText(
                  text: new TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                      style: new TextStyle(
                        fontSize: 16.0,
                      ),
                  children: <TextSpan>[
                    new TextSpan(text: 'Height: ', style: new TextStyle(fontWeight: FontWeight.bold)),
                    new TextSpan(text: widget.pokemonObject.getHeight())
                  ]
                  ,
                  )
              ),
              SizedBox(height: 5),
              RichText(
                  text: new TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                    children: <TextSpan>[
                      new TextSpan(text: 'Weight: ', style: new TextStyle(fontWeight: FontWeight.bold)),
                      new TextSpan(text: widget.pokemonObject.getWeight())
                    ]
                    ,
                  )
              ),
              SizedBox(height: 5),
              // PokemonTypeRow(widget.pokemonObject.typesImageURL),
              _buildAbilityRow(context, widget.pokemonObject.abilities),
              // Text('Types: ${widget.pokemonObject.getListContents(widget.pokemonObject.types)}'),
              // _buildTypeRow(context, widget.pokemonObject.typesImageURL),
              RichText(
                  text: new TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                    children: <TextSpan>[
                      new TextSpan(text: 'Description: ', style: new TextStyle(fontWeight: FontWeight.bold)),
                    ]
                    ,
                  )
              ),
              Padding(
                padding:  const EdgeInsets.only(right: 55.0),
                child:
                  Text('${widget.pokemonObject.getPokedexEntry()}'),

              ),
              SizedBox(height: 25),

              if (widget.isFromPokedex && pokemonTeams.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 0, right: 35),
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DropdownButtonFormField<PokemonTeam>(
                      // value: selectedPokemonTeam,
                      hint: Text("Pick a team"),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      // underline: Container(
                      //   height: 2,
                      //   color: Colors.deepPurpleAccent,
                      // ),
                      onChanged: (PokemonTeam? newValue) {
                        setState(() {
                          selectedPokemonTeam = newValue!;

                          // print("onchanged: "+selectedPokemonTeam.name);
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
                    SizedBox(height: 5),
                    ElevatedButton(
                        onPressed: () {
                          print("ONPRESS: "+selectedPokemonTeam.name);
                          if (selectedPokemonTeam.pokemonTeam.length < 6) {
                            selectedPokemonTeam.pokemonTeam.add(widget.pokemonObject);
                            selectedPokemonTeam.pokemonTeam.elementAt(0);
                            // if (selectedPokemonTeam.pokemonTeamTypes.isEmpty) {
                              for(var type in widget.pokemonObject.types) {
                                print("NONE");
                                selectedPokemonTeam.pokemonTeamTypes.add(type.name);
                              }
                            // }
                            // else {
                            //   List tempList = [];
                            //   for(var typeTop in widget.pokemonObject.types) {
                            //     // var contain = listOfDownloadedFile.where((element) => element.Url == "your URL link")
                            //     // print("FIRST LEVEL: "+typeTop.name);
                            //     // // for(var type in widget.pokemonObject.types) {
                            //     //   print("SECOND LEVEL: "+type.name);
                            //       if(!selectedPokemonTeam.pokemonTeamTypes.contains(typeTop.name)) {
                            //         // print("DEEP INSIDE " + typeTop.name);
                            //         tempList.add(typeTop.name);
                            //       }
                            //     // }
                            //
                            //   }
                            //   selectedPokemonTeam.pokemonTeamTypes.addAll(tempList);
                            //   tempList = [];
                            // }
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
                        child: Text("Add to team")),
                    // Text("data")
                  ],
              ),
                )
            ],
          ),
        ),
      );
    // } else {
    //
    //
    //   return Padding(
    //     padding: const EdgeInsets.only(left: 80.0, right: 25.0),
    //     child: Center(
    //       child: Column(
    //         // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           SizedBox(height: 40),
    //           Text(
    //             widget.pokemonObject.id.toString().padLeft(3, '0'),
    //             style:  TextStyle(
    //               fontWeight: FontWeight.bold,
    //               fontSize: 20,
    //             ),
    //           ),
    //           SizedBox(height: 15),
    //           Text(
    //             widget.pokemonObject.name.toString().toTitleCase(),
    //             style:  TextStyle(
    //               fontWeight: FontWeight.bold,
    //               fontSize: 20,
    //             ),
    //           ),
    //           // SizedBox(height: 20),
    //           Padding(
    //             padding: const EdgeInsets.only(left: 10.0),
    //             child: spritePlaceholder,
    //             // child: Image.network(
    //             //     pokemonURL.isEmpty ? widget.pokemonObject.spriteURL : pokemonURL,
    //             //   scale: .5,
    //             // ),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.only(left: 40.0),
    //             child: Row(
    //               // mainAxisAlignment: MainAxisAlignment.center,
    //               // crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text('Shiny Version'),
    //                 Switch(
    //                     value: isSwitched,
    //                     onChanged: (value) {
    //                       setState(() {
    //                         if(!value) {
    //                           // pokemonURL = widget.pokemonObject.spriteURL;
    //                           spritePlaceholder = sprite;
    //                         }
    //                         else {
    //                           spritePlaceholder = shinySprite;
    //                           // pokemonURL = widget.pokemonObject.shinySpriteURL;
    //                         }
    //                         isSwitched = value;
    //                       });
    //                     })
    //               ],
    //             ),
    //           ),
    //           PokemonTypeRow(widget.pokemonObject.typesImageURL, false),
    //           SizedBox(height: 25),
    //           RichText(
    //               text: new TextSpan(
    //                 // Note: Styles for TextSpans must be explicitly defined.
    //                 // Child text spans will inherit styles from parent
    //                 style: new TextStyle(
    //                   fontSize: 16.0,
    //                 ),
    //                 children: <TextSpan>[
    //                   new TextSpan(text: 'Height: ', style: new TextStyle(fontWeight: FontWeight.bold)),
    //                   new TextSpan(text: widget.pokemonObject.getHeight())
    //                 ]
    //                 ,
    //               )
    //           ),
    //           SizedBox(height: 5),
    //           RichText(
    //               text: new TextSpan(
    //                 // Note: Styles for TextSpans must be explicitly defined.
    //                 // Child text spans will inherit styles from parent
    //                 style: new TextStyle(
    //                   fontSize: 16.0,
    //                 ),
    //                 children: <TextSpan>[
    //                   new TextSpan(text: 'Weight: ', style: new TextStyle(fontWeight: FontWeight.bold)),
    //                   new TextSpan(text: widget.pokemonObject.getWeight())
    //                 ]
    //                 ,
    //               )
    //           ),
    //           SizedBox(height: 5),
    //           // PokemonTypeRow(widget.pokemonObject.typesImageURL),
    //           _buildAbilityRow(context, widget.pokemonObject.abilities),
    //           // Text('Types: ${widget.pokemonObject.getListContents(widget.pokemonObject.types)}'),
    //           // _buildTypeRow(context, widget.pokemonObject.typesImageURL),
    //           RichText(
    //               text: new TextSpan(
    //                 // Note: Styles for TextSpans must be explicitly defined.
    //                 // Child text spans will inherit styles from parent
    //                 style: new TextStyle(
    //                   fontSize: 16.0,
    //                 ),
    //                 children: <TextSpan>[
    //                   new TextSpan(text: 'Description: ', style: new TextStyle(fontWeight: FontWeight.bold)),
    //                 ]
    //                 ,
    //               )
    //           ),
    //           Padding(
    //             padding:  const EdgeInsets.only(right: 55.0),
    //             child:
    //             Text('${widget.pokemonObject.getPokedexEntry()}'),
    //
    //           ),
    //           SizedBox(height: 25),
    //
    //           if (widget.isFromPokedex && pokemonTeams.isNotEmpty)
    //             Padding(
    //               padding: const EdgeInsets.only(left: 0, right: 35),
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   DropdownButtonFormField<PokemonTeam>(
    //                     // value: selectedPokemonTeam,
    //                     hint: Text("Pick a team"),
    //                     iconSize: 24,
    //                     elevation: 16,
    //                     style: const TextStyle(color: Colors.deepPurple),
    //                     // underline: Container(
    //                     //   height: 2,
    //                     //   color: Colors.deepPurpleAccent,
    //                     // ),
    //                     onChanged: (PokemonTeam? newValue) {
    //                       setState(() {
    //                         selectedPokemonTeam = newValue!;
    //
    //                         // print("onchanged: "+selectedPokemonTeam.name);
    //                       });
    //                     },
    //                     // items: pokemonT
    //                     items: pokemonTeams
    //                         .map((PokemonTeam pokemonTeam) {
    //                       return DropdownMenuItem<PokemonTeam>(
    //                         value: pokemonTeam,
    //                         child: Text(pokemonTeam.name),
    //                       );
    //                     }).toList(),
    //                   ),
    //                   SizedBox(height: 5),
    //                   ElevatedButton(
    //                       onPressed: () {
    //                         print("ONPRESS: "+selectedPokemonTeam.name);
    //                         if (selectedPokemonTeam.pokemonTeam.length < 6) {
    //                           selectedPokemonTeam.pokemonTeam.add(widget.pokemonObject);
    //                           selectedPokemonTeam.pokemonTeam.elementAt(0);
    //                           // if (selectedPokemonTeam.pokemonTeamTypes.isEmpty) {
    //                           for(var type in widget.pokemonObject.types) {
    //                             print("NONE");
    //                             selectedPokemonTeam.pokemonTeamTypes.add(type.name);
    //                           }
    //                           // }
    //                           // else {
    //                           //   List tempList = [];
    //                           //   for(var typeTop in widget.pokemonObject.types) {
    //                           //     // var contain = listOfDownloadedFile.where((element) => element.Url == "your URL link")
    //                           //     // print("FIRST LEVEL: "+typeTop.name);
    //                           //     // // for(var type in widget.pokemonObject.types) {
    //                           //     //   print("SECOND LEVEL: "+type.name);
    //                           //       if(!selectedPokemonTeam.pokemonTeamTypes.contains(typeTop.name)) {
    //                           //         // print("DEEP INSIDE " + typeTop.name);
    //                           //         tempList.add(typeTop.name);
    //                           //       }
    //                           //     // }
    //                           //
    //                           //   }
    //                           //   selectedPokemonTeam.pokemonTeamTypes.addAll(tempList);
    //                           //   tempList = [];
    //                           // }
    //                           // for(var typeTop in selectedPokemonTeam.pokemonTeamTypes) {
    //                           //
    //                           //   for(var type in widget.pokemonObject.types) {
    //                           //     if(!typeTop.name.toString().contains(type.name.toString())) {
    //                           //       print("inside");
    //                           //       selectedPokemonTeam.pokemonTeamTypes.add(type.name);
    //                           //     }
    //                           //   }
    //                           //
    //                           // }
    //                           // for(var type in widget.pokemonObject.types) {
    //                           //   print('Type: ${type.name} inside? ${selectedPokemonTeam.pokemonTeamTypes.contains(type)}');
    //                           //   if (!selectedPokemonTeam.pokemonTeamTypes.contains(type.name.toString())) {
    //                           //     print("inside");
    //                           //     selectedPokemonTeam.pokemonTeamTypes.add(type);
    //                           //   }
    //                           // }
    //                           final snackBar = SnackBar(content: Text('Added: ${widget.pokemonObject.name.toString().toTitleCase()} to ${selectedPokemonTeam.name}'));
    //
    //                           // Find the ScaffoldMessenger in the widget tree
    //                           // and use it to show a SnackBar.
    //                           ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //                         }
    //                         else {
    //                           final snackBar = SnackBar(content: Text('You have reached the maximum number of pokemon in ${selectedPokemonTeam.name}. Remove one before adding another.'));
    //
    //                           // Find the ScaffoldMessenger in the widget tree
    //                           // and use it to show a SnackBar.
    //                           ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //                         }
    //
    //                       },
    //                       child: Text("Add to team")),
    //                   // Text("data")
    //                 ],
    //               ),
    //             )
    //         ],
    //       ),
    //     ),
    //   );
    }
  }

  Widget _buildAbilityRow(BuildContext context, List<Ability> abilities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
            text: new TextSpan(
              style: new TextStyle(
                fontSize: 16.0,
              ),
              children: <TextSpan>[
                new TextSpan(text: 'Abilities: ', style: new TextStyle(fontWeight: FontWeight.bold))
              ],
            )
        ),
        Row(
          children: [
            ..._buildAbilityRowList(abilities),
          ],
        )

    ],
    );
  }

  List<Widget> _buildAbilityRowList(List<Ability> abilityList) {
    List<Widget> abilities = [];
    for(Ability ability in abilityList) {
      TextButton abilityWidget =
          TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialog(context, ability),
                );
              },
              child: Text(
                ability.name.toTitleCase(),
                style: new TextStyle(
                  fontSize: 16.0,
                ),
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