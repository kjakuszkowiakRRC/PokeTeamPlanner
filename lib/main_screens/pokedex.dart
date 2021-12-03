import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:poke_team_planner/main_screens/pokemon_detail_page.dart';
import 'package:poke_team_planner/main_screens/settings.dart';
import 'package:poke_team_planner/universal/account_alert.dart';
import 'package:poke_team_planner/universal/pokemon_type_row.dart';
import 'package:poke_team_planner/user_screens/login_page.dart';
import 'package:poke_team_planner/utils/pokedex_entry.dart';
import 'package:poke_team_planner/utils/string_extension.dart';

import 'package:flutter/material.dart';
import 'package:poke_team_planner/universal/poke_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:poke_team_planner/utils/pokemon.dart';

import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

//TODO: figure out why new pokemon images lag when switching for first time
//TODO: caching into a local file
//TODO: refactor some code
class Pokedex extends StatefulWidget {
  const Pokedex({Key? key}) : super(key: key);

  @override
  State<Pokedex> createState() => _PokedexState2();
}

class _PokedexState2 extends State<Pokedex> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<int> verticalData = [];
  late Future<List<Pokemon>> futurePokemon;
  late List pokemonTypeList;
  List<Pokemon> basePokemonList = [];
  late List<Pokemon> alteredPokemonList = [];
  late List<Pokemon> viewPokemonList = [];
  late String _dropDownValue = "Choose a filter";

  final int increment = 10;
  int lazyListCounter = 0;

  bool isLoadingVertical = false;
  bool isLoadingHorizontal = false;

  bool endOfList = false;
  late SearchBar searchBar;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: Text('Pokedex'),
      actions: [searchBar.getSearchAction(context)
      ],
    );
  }

  Future<void> onSubmitted(String value) async {
    final pokemonResponse = await http
      .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/${value.toLowerCase()}'));

  if (pokemonResponse.statusCode == 200) {
    Pokemon pokemon = new Pokemon.fromJson(
        jsonDecode(pokemonResponse.body));

    final pokedexEntryResponse = await http
        .get(Uri.parse(
        'https://pokeapi.co/api/v2/pokemon-species/${pokemon.name}'));

    if (pokedexEntryResponse.statusCode == 200) {
      Map firstMap = json.decode(pokedexEntryResponse.body);
      List jsonResponse = firstMap['flavor_text_entries'];
      for (var key in jsonResponse) {
        if (key['language']['name'] == 'en') {
          // print(pokemon.pokedexEntry);
          pokemon.pokedexEntry = key['flavor_text'];
        }
      }
    }
    else {
      throw Exception('Failed to load Pokedex entry');
    }

    pokemon.typesImageURL = [];

    for (var pokemonType in pokemon.types) {
      for (var type in pokemonTypeList) {
        if (type['name'] == pokemonType.name) {
          pokemon.typesImageURL!.add(type['image_path']);
        }
      }
    }
    basePokemonList = viewPokemonList;
    viewPokemonList.clear();
    alteredPokemonList.addAll(
        List.generate(
            1, (index) => pokemon));
    viewPokemonList = alteredPokemonList;

  }
  else {
    ScaffoldMessenger.maybeOf(context)
        ?.showSnackBar(new SnackBar(content: new Text('No such Pokemon named "$value"!')));
    throw Exception('Failed to load Pokemon');
  }
    setState(() {
      var context = _scaffoldKey.currentContext;

      if (context == null) {
        return;
      }




      ScaffoldMessenger.maybeOf(context)
          ?.showSnackBar(new SnackBar(content: new Text('You wrote "$value"!')));
    });
  }

  Future<List<Pokemon>> fetchPokemon() async {
    final response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/?limit=1'));
    if (response.statusCode == 200) {
      List<Pokemon> pokemonList = [];
      int listSize = 12;
      for(var i = 0; i < 20; i++) {
        final pokemonResponse = await http
            .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/${i+1}'));
        if(pokemonResponse.statusCode == 200) {
          Pokemon pokemon = new Pokemon.fromJson(jsonDecode(pokemonResponse.body));

          final pokedexEntryResponse = await http
              .get(Uri.parse('https://pokeapi.co/api/v2/pokemon-species/${pokemon.name}'));

          if (response.statusCode == 200) {
            pokemon.pokedexEntry = jsonDecode(pokedexEntryResponse.body)['flavor_text_entries'][0]['flavor_text'];
          }
          else {
            throw Exception('Failed to load Pokedex entry');
          }

          pokemon.typesImageURL = [];

          for(var pokemonType in pokemon.types) {
            for (var type in pokemonTypeList){
              if(type['name'] == pokemonType.name) {
                pokemon.typesImageURL!.add(type['image_path']);
              }
            }
          }
          pokemonList.add(pokemon);
        }
        else {
          throw Exception('Failed to load Pokemon');
        }
      }
      return pokemonList;
    } else {
      throw Exception('Failed to load Pokemon');
    }
  }



  Future<String> loadJsonData() async {
    var jsonText = await rootBundle.loadString('assets/types.json');
    setState(() => pokemonTypeList = json.decode(jsonText));
    return 'success';
  }

  @override
  void initState() {
    _loadMoreVertical();
    super.initState();
    // futurePokemon = fetchPokemon();
    this.loadJsonData();
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: onSubmitted,
        buildDefaultAppBar: buildAppBar
    );
  }



  Future _loadMoreVertical() async {
    if(_dropDownValue.isNotEmpty && _dropDownValue != "Choose a filter") {
      _loadTypes();
    }
    else {
      int endOfListCounter = 0;

      int alternateFormCounter = 0;
      setState(() {
        isLoadingVertical = true;
      });

      // Add in an artificial delay
      // await new Future.delayed(const Duration(seconds: 2));

      //put pokemon stuff under here

      List<Pokemon> pokemonListFiller = [];
      int listSize = 10;
      // int listSize = 20;
      // final snackBar = SnackBar(content: Text("HELLO"));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      for (var i = lazyListCounter;  !endOfList && i < lazyListCounter + 10; i++) {
        // print(pokemon.url);
        // print("BEFORE");
        final pokemonResponse = await http
            .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/${i + 1}'));
        // print("HELLO");
        if (pokemonResponse.statusCode == 200) {
          // print("MORE FIRST");
          Pokemon pokemon = new Pokemon.fromJson(
              jsonDecode(pokemonResponse.body));

          String pokemonNameAltered = pokemon.name;
          if (pokemon.name.indexOf('-') > 0 && pokemon.name.substring(pokemon.name.indexOf('-'), pokemon.name.length).length > 3) {
            pokemonNameAltered = pokemon.name.substring(0, pokemon.name.indexOf('-'));
            alternateFormCounter++;
            if(alternateFormCounter == 2) {
              endOfList = true;
            }
          }
          // String pokemonNameAltered = pokemon.name.substring(0, pokemon.name.indexOf('-'));
          final pokedexEntryResponse = await http
              .get(Uri.parse(
              'https://pokeapi.co/api/v2/pokemon-species/${pokemonNameAltered}'));

          if (pokedexEntryResponse.statusCode == 200) {
            Map firstMap = json.decode(pokedexEntryResponse.body);
            List jsonResponse = firstMap['flavor_text_entries'];
            for (var key in jsonResponse) {
              if (key['language']['name'] == 'en') {
                // print(pokemon.pokedexEntry);
                pokemon.pokedexEntry = key['flavor_text'];
              }
            }

              // pokemon.pokedexEntry = jsonDecode(pokedexEntryResponse
              //   .body)['flavor_text_entries'][0]['flavor_text'];
          }
          else {
            throw Exception('Failed to load Pokedex entry');
          }


          for(var ability in pokemon.abilities) {

            final response = await http
                .get(Uri.parse('https://pokeapi.co/api/v2/ability/${ability.name}'));
            Map firstMap = json.decode(response.body);
            List jsonResponse = firstMap['effect_entries'];
            for (var key in jsonResponse){
              if(key['language']['name'] == 'en') {
                ability.description = key['effect'];
              }

            }
          }

          pokemon.typesImageURL = [];

          for (var pokemonType in pokemon.types) {
            for (var type in pokemonTypeList) {
              if (type['name'] == pokemonType.name) {
                pokemon.typesImageURL!.add(type['image_path']);
              }
            }
          }
          pokemonListFiller.add(pokemon);
          endOfListCounter++;
          // print("BIG LIST " + pokemonListFiller.elementAt(0).name + " | LENMGTGH: " + pokemonListFiller.length.toString());

        }
        else {
          throw Exception('Failed to load Pokemon');
        }
      }

      int incrementer = 10;
      if(pokemonListFiller.length < 10) {
        incrementer = endOfListCounter-1;
      }
      if(pokemonListFiller.isNotEmpty) {
        basePokemonList.addAll(
            List.generate(
                incrementer, (index) => pokemonListFiller.elementAt(index)));
        viewPokemonList = basePokemonList;
        // print("BIG LIST " + pokemonList.last.name + " | LENMGTGH: " + pokemonList.length.toString());
        // }
        lazyListCounter += 10;
      }

      setState(() {
        isLoadingVertical = false;
      });
    }

  }



  Future _loadTypes() async {
    // bool endOfList = false;
    int endOfListCounter = 0;
    int alternateFormCounter = 0;


    // Add in an artificial delay
    // await new Future.delayed(const Duration(seconds: 2));

    //put pokemon stuff under here

    List<Pokemon> pokemonListFiller = [];

    final pokemonResponse = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/type/${_dropDownValue.toLowerCase()}'));

      // List parsedListJson = jsonDecode(pokemonResponse.body.toString());
      // List<Pokemon> pokemonList = List<Pokemon>.from(parsedListJson.map((i) => Pokemon.fromJson(i)));

    // print(data[0]);

      // print(pokemonList);

    if (pokemonResponse.statusCode == 200) {
      Map pokemonTypeMap = json.decode(pokemonResponse.body.toString());
      List pokemonList = pokemonTypeMap["pokemon"];
      // Iterable<Pokemon> jsonResponseTEST = pokemonList.map((pokemon) => new Pokemon.fromJson(pokemon)).toList();

      int listSize = 10;
      for (var i = lazyListCounter; !endOfList && i < lazyListCounter + 10; i++) {
        // print(pokemon.url);
        // print(pokemonList.elementAt(i));
        // print(pokemonList.elementAt(i)["pokemon"]["name"]);
        // print("alternateFormCounter: ${alternateFormCounter}");
        final pokemonResponse = await http
            .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/${pokemonList.elementAt(i)["pokemon"]["name"]}'));
        // print("HELLO");
        if (pokemonResponse.statusCode == 200) {
          // print("MORE FIRST");
          Pokemon pokemon = new Pokemon.fromJson(
              jsonDecode(pokemonResponse.body));
          // print("BIG LIST " + pokemon.name + " | LENMGTGH: " + pokemonListFiller.length.toString());

          String pokemonNameAltered = pokemon.name;
          if (pokemon.name.indexOf('-') > 0 && pokemon.name.substring(pokemon.name.indexOf('-'), pokemon.name.length).length > 3) {
            pokemonNameAltered = pokemon.name.substring(0, pokemon.name.indexOf('-'));
            alternateFormCounter++;
            if(alternateFormCounter == 2) {
              endOfList = true;
            }
          }
          // String pokemonNameAltered = pokemon.name.substring(0, pokemon.name.indexOf('-'));
          final pokedexEntryResponse = await http
              .get(Uri.parse(
              'https://pokeapi.co/api/v2/pokemon-species/${pokemonNameAltered}'));

          if (pokedexEntryResponse.statusCode == 200) {
            Map firstMap = json.decode(pokedexEntryResponse.body);
            List jsonResponse = firstMap['flavor_text_entries'];
            for (var key in jsonResponse) {
              if (key['language']['name'] == 'en') {
                // print(pokemon.pokedexEntry);
                pokemon.pokedexEntry = key['flavor_text'];
              }
            }
          }
          else {
            // basePokemonList.addAll(
          //     List.generate(
          //         10, (index) => pokemonListFiller.elementAt(index)));
          // viewPokemonList = basePokemonList;
            throw Exception('Failed to load Pokedex entry');
          }

          pokemon.typesImageURL = [];

          for (var pokemonType in pokemon.types) {
            for (var type in pokemonTypeList) {
              if (type['name'] == pokemonType.name) {
                pokemon.typesImageURL!.add(type['image_path']);
              }
            }
          }
          pokemonListFiller.add(pokemon);
          // endOfListCounter++;
          // print("BIG LIST " + pokemonListFiller.elementAt(endOfListCounter).name + " | LENMGTGH: " + pokemonListFiller.length.toString());

          endOfListCounter++;
        }
        else {
          // endOfList = true;
          throw Exception('Failed to load Pokemon');

        }
      }
      // for(Pokemon pokemon in pokemonListFiller) {
      // print("BIG LIST " + pokemonListFiller.elementAt(0).name + " | LENMGTGH: " + pokemonListFiller.length.toString());
      int incrementer = 10;
      if(pokemonListFiller.length < 10) {
        incrementer = endOfListCounter-1;
      }
      if(pokemonListFiller.isNotEmpty) {
        basePokemonList.addAll(
            List.generate(
                incrementer, (index) => pokemonListFiller.elementAt(index)));
        viewPokemonList = basePokemonList;
        // print("BIG LIST " + pokemonList.last.name + " | LENMGTGH: " + pokemonList.length.toString());
        // }
        lazyListCounter += 10;
      }
      // basePokemonList.addAll(
      //     List.generate(
      //         incrementer, (index) => pokemonListFiller.elementAt(index)));
      // viewPokemonList = basePokemonList;
      // // print("BIG LIST " + pokemonList.last.name + " | LENMGTGH: " + pokemonList.length.toString());
      // // }
      // lazyListCounter += 10;

      setState(() {
        isLoadingVertical = false;
      });
      // List pokemon = jsonDecode(pokemonResponse.body);
      // print(pokemon);

    }
    else {
      throw Exception('Failed to load types list');
    }
    // int listSize = 10;
    //
    // // int listSize = 20;
    // // final snackBar = SnackBar(content: Text("HELLO"));
    // // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // for (var i = lazyListCounter; i < lazyListCounter + 10; i++) {
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
    //     final pokedexEntryResponse = await http
    //         .get(Uri.parse(
    //         'https://pokeapi.co/api/v2/pokemon-species/${pokemon.name}'));
    //
    //     if (pokedexEntryResponse.statusCode == 200) {
    //       pokemon.pokedexEntry = jsonDecode(pokedexEntryResponse
    //           .body)['flavor_text_entries'][0]['flavor_text'];
    //     }
    //     else {
    //       throw Exception('Failed to load Pokedex entry');
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
    //     print("BIG LIST " + pokemonListFiller.elementAt(0).name + " | LENMGTGH: " + pokemonListFiller.length.toString());
    //
    //   }
    //   else {
    //     throw Exception('Failed to load Pokemon');
    //   }
    // }
    // for(Pokemon pokemon in pokemonListFiller) {
    // print("BIG LIST " + pokemonListFiller.elementAt(0).name + " | LENMGTGH: " + pokemonListFiller.length.toString());
    // basePokemonList.addAll(
    //     List.generate(
    //         10, (index) => pokemonListFiller.elementAt(index)));
    // viewPokemonList = basePokemonList;
    // // print("BIG LIST " + pokemonList.last.name + " | LENMGTGH: " + pokemonList.length.toString());
    // // }
    // lazyListCounter += 10;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      key: _scaffoldKey,
      body: LazyLoadScrollView(
                isLoading: isLoadingVertical,
                onEndOfPage: () => _loadMoreVertical(),
                child: Scrollbar(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      // Padding(padding: const EdgeInsets.all(8.0),
                      // child: getButton()),
                      TextButton(
                      onPressed: () {
                        setState(() {
                          _dropDownValue = "Choose a filter";
                          lazyListCounter = 0;
                          endOfList = false;
                          viewPokemonList.clear();
                          _loadMoreVertical();
                        });
                      },
                    child: Text("Reset Page")),
                      DropdownButton<String>(
                        hint: _dropDownValue == null
                            ? Text('Filter by Type')
                            : Text(
                          _dropDownValue,
                          style: TextStyle(color: Colors.blue),
                        ),
                        isExpanded: true,
                        iconSize: 30.0,
                        style: TextStyle(color: Colors.blue),
                        items: [
                          'Bug',
                          'Dark',
                          'Dragon',
                          'Electric',
                          'Fairy',
                          'Fighting',
                          'Fire',
                          'Flying',
                          'Grass',
                          'Ghost',
                          'Ground',
                          'Ice',
                          'Normal',
                          'Water',
                          'Poison',
                          'Psychic',
                          'Steel',
                          'Rock'].map(
                              (val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(val),
                            );
                          },
                        ).toList(),
                        onChanged: (val) {
                          setState(
                                () {
                                  lazyListCounter = 0;
                                  endOfList = false;
                                  viewPokemonList.clear();
                                  _dropDownValue = val!;
                                  _loadTypes();
                            },
                          );
                        },
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: viewPokemonList.length,
                        itemBuilder: (context, position) {
                          // viewPokemonList.elementAt(position);
                          return PokedexEntry(viewPokemonList.elementAt(position), true);
                        },
                      ),
                    ],
                  ),
                ),
              )
    );
  }

  GestureDetector _pokedexEntry(int index, String title, Pokemon pokemon) {
    return GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PokemonDetailPage(pokemonObject: pokemon, isFromPokedex: true,),
            ),
          );
        },
        child: Row(
          children: [
            // stopping this so i dont get blocked
            // Image.network(pokemon.spriteURL),
            Column(
              children: [
                Row(
                  children: [
                    Text("${index + 1}. ${title.toTitleCase()}",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        )
                    )
                  ],
                ),
                Row(
                  children: [
                    PokemonTypeRow(pokemon.typesImageURL, true)
                  ],
                )
              ],
            ),
          ],
        )
    );
  }

  Widget getButton() {
    if(alteredPokemonList.isNotEmpty) {
      return TextButton(
          onPressed: reloadFullList(),
          child: Text("Reset Page"));
    }
    else {
      return SizedBox.shrink();
    }

  }

  reloadFullList() {
    // viewPokemonList.clear();
    // viewPokemonList = basePokemonList;

    setState(() {
    });

  }
}



