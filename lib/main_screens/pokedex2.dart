import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:poke_team_planner/main_screens/pokemon_detail_page.dart';
import 'package:poke_team_planner/main_screens/settings.dart';
import 'package:poke_team_planner/universal/account_alert.dart';
import 'package:poke_team_planner/universal/pokemon_type_row.dart';
import 'package:poke_team_planner/user_screens/login_page.dart';
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

//TODO: add search bar
//TODO: refactor pokemon api calls out
//TODO: add filter for types
//TODO: use https://pokeapi.co/api/v2/type/12/ and the like for filtering by type
//TODO: figure out why new pokemon images lag when switching for first time
//TODO: caching into a local file
class Pokedex2 extends StatefulWidget {
  const Pokedex2({Key? key}) : super(key: key);

  @override
  State<Pokedex2> createState() => _PokedexState2();
}

class _PokedexState2 extends State<Pokedex2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<int> verticalData = [];
  late Future<List<Pokemon>> futurePokemon;
  late List pokemonTypeList;
  List<Pokemon> basePokemonList = [];
  late List<Pokemon> alteredPokemonList = [];
  late List<Pokemon> viewPokemonList = [];

  final int increment = 10;
  int lazyListCounter = 0;

  bool isLoadingVertical = false;
  bool isLoadingHorizontal = false;
  late SearchBar searchBar;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: Text('Poke Team Builder'),
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
      pokemon.pokedexEntry = jsonDecode(pokedexEntryResponse
          .body)['flavor_text_entries'][0]['flavor_text'];
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
    setState(() {
      isLoadingVertical = true;
    });

    // Add in an artificial delay
    await new Future.delayed(const Duration(seconds: 2));

    //put pokemon stuff under here

    List<Pokemon> pokemonListFiller = [];
    int listSize = 10;
    // int listSize = 20;
    // final snackBar = SnackBar(content: Text("HELLO"));
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    for (var i = lazyListCounter; i < lazyListCounter + 10; i++) {
      // print(pokemon.url);
      // print("BEFORE");
      final pokemonResponse = await http
          .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/${i + 1}'));
      // print("HELLO");
      if (pokemonResponse.statusCode == 200) {
        // print("MORE FIRST");
        Pokemon pokemon = new Pokemon.fromJson(
            jsonDecode(pokemonResponse.body));

        final pokedexEntryResponse = await http
            .get(Uri.parse(
            'https://pokeapi.co/api/v2/pokemon-species/${pokemon.name}'));

        if (pokedexEntryResponse.statusCode == 200) {
          pokemon.pokedexEntry = jsonDecode(pokedexEntryResponse
              .body)['flavor_text_entries'][0]['flavor_text'];
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
        pokemonListFiller.add(pokemon);
        print("BIG LIST " + pokemonListFiller.elementAt(0).name + " | LENMGTGH: " + pokemonListFiller.length.toString());

      }
      else {
        throw Exception('Failed to load Pokemon');
      }
    }
    // for(Pokemon pokemon in pokemonListFiller) {
    // print("BIG LIST " + pokemonListFiller.elementAt(0).name + " | LENMGTGH: " + pokemonListFiller.length.toString());
    basePokemonList.addAll(
        List.generate(
            10, (index) => pokemonListFiller.elementAt(index)));
    viewPokemonList = basePokemonList;
    // print("BIG LIST " + pokemonList.last.name + " | LENMGTGH: " + pokemonList.length.toString());
    // }
    lazyListCounter += 10;

    setState(() {
      isLoadingVertical = false;
    });
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
                          lazyListCounter = 0;
                          viewPokemonList.clear();
                          _loadMoreVertical();
                        });
print(basePokemonList.length);
                        print("THIS IS A TEST");
                      },
                    child: Text("Reset Page")),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: viewPokemonList.length,
                        itemBuilder: (context, position) {
                          viewPokemonList.elementAt(position);
                          return PokedexEntry(viewPokemonList.elementAt(position), position);
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
              builder: (context) => PokemonDetailPage(pokemonObject: pokemon),
            ),
          );
        },
        child: Row(
          children: [
            Image.network(pokemon.spriteURL),
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
                    PokemonTypeRow(pokemon.typesImageURL)
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
    print("THIS IS A TEST");
    // viewPokemonList = basePokemonList;

    setState(() {
    });

  }
}

class PokedexEntry extends StatelessWidget {
  final Pokemon pokemon;
  final int position;

  const PokedexEntry(
      this.pokemon,
      this.position, {
        Key? key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PokemonDetailPage(pokemonObject: pokemon),
            ),
          );
        },
        child: Row(
          children: [
            Image.network(pokemon.spriteURL),
            Column(
              children: [
                Row(
                  children: [
                    Text("${position + 1}. ${pokemon.name.toTitleCase()}",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        )
                    )
                  ],
                ),
                Row(
                  children: [
                    PokemonTypeRow(pokemon.typesImageURL)
                  ],
                )
              ],
            ),
          ],
        )
    );
  }
}

