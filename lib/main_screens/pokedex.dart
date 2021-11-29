import 'dart:convert';
import 'package:poke_team_planner/main_screens/pokemon_detail_page.dart';
import 'package:poke_team_planner/universal/pokemon_type_row.dart';
import 'package:poke_team_planner/utils/string_extension.dart';

import 'package:flutter/material.dart';
import 'package:poke_team_planner/universal/poke_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:poke_team_planner/utils/pokemon.dart';

import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

//TODO: add types to each entry
//TODO: add search bar
//TODO: add filter for types
//TODO: fix slow loading speed
//TODO: use https://pokeapi.co/api/v2/type/12/ and the like for filtering by type
//TODO: figure out why new pokemon images lag when switching for first time
//TODO: caching into a local file or lazy loading list
class Pokedex extends StatefulWidget {
  const Pokedex({Key? key}) : super(key: key);

  @override
  State<Pokedex> createState() => _PokedexState();
}

class _PokedexState extends State<Pokedex> {
  late Future<List<Pokemon>> futurePokemon;
  late List pokemonTypeList;


  Future<List<Pokemon>> fetchPokemon() async {
    final response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/?limit=1'));
    if (response.statusCode == 200) {
      List<Pokemon> pokemonList = [];
      int listSize = 151;
      for(var i = 0; i < listSize; i++) {
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
    super.initState();
    futurePokemon = fetchPokemon();
    this.loadJsonData();
  }

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
              FutureBuilder<List<Pokemon>>(
                future: futurePokemon,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Flexible(
                        flex: 1,
                        child:
                            new Container(
                                child: _jobsListView(snapshot.data)
                            )
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  return const CircularProgressIndicator();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  ListView _jobsListView(data) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _pokedexEntry(index, data[index].name, data[index]);
        });
  }

  ListTile _tile(int index, String title, Pokemon pokemon) {
    return ListTile(
      title: Text("${index + 1}. ${title.toTitleCase()}",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )
      ),
      subtitle: Text(pokemon.getListContents(pokemon.types)),
      leading: Image.network(pokemon.spriteURL),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PokemonDetailPage(pokemonObject: pokemon),
          ),
        );
      },

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
}
