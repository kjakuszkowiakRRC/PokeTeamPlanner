import 'dart:convert';
import 'package:poke_team_planner/main_screens/pokemon_detail_page.dart';
import 'package:poke_team_planner/utils/pokemon_details.dart';
import 'package:poke_team_planner/utils/string_extension.dart';

import 'package:flutter/material.dart';
import 'package:poke_team_planner/universal/poke_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:poke_team_planner/utils/pokemon.dart';

//TODO: add types to each entry
//TODO: add search bar
//TODO: add filter for types
//TODO: fix slow loading speed
//TODO: create all the pokemon objects then pass to list to incrementaslly add to screen to lower wait time

class Pokedex extends StatefulWidget {
  const Pokedex({Key? key}) : super(key: key);

  @override
  State<Pokedex> createState() => _PokedexState();
}

class _PokedexState extends State<Pokedex> {
  late Future<List<Pokemon>> futurePokemon;

  Future<List<Pokemon>> fetchPokemon() async {
    final response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/?limit=151'));
    if (response.statusCode == 200) {
      Map firstMap = json.decode(response.body);
      List jsonResponse = firstMap["results"];
      List<Pokemon> pokemonList = jsonResponse
          .map((pokemon) => new Pokemon.fromJson(pokemon))
          .toList();
      for(Pokemon pokemon in pokemonList) {
        final responsePokemonDetails = await http
            .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/${pokemon.name}'));
        PokemonDetails pokemonDetails = new PokemonDetails.fromJson(jsonDecode(responsePokemonDetails.body));
        pokemon.pokemonDetails = pokemonDetails;
      }
      return pokemonList;
    } else {
      throw Exception('Failed to load Pokemon');
    }
  }

  Future<PokemonDetails> fetchPokemonDetails(String url) async {
    print(url);
    final response = await http
        .get(Uri.parse(url));

    if (response.statusCode == 200) {
      return PokemonDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Pokemon');
    }
  }

  @override
  void initState() {
    super.initState();
    futurePokemon = fetchPokemon();
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

                  // By default, show a loading spinner.
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
          return _tile(index, data[index].name, data[index].pokemonDetails, data[index]);
        });
  }

  ListTile _tile(int index, String title, PokemonDetails pokemonDetails, Pokemon pokemon) {
    return ListTile(
      title: Text("${index + 1}. ${title.toTitleCase()}",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )
      ),
      leading: Image.network(pokemonDetails.imageURL),
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
}
