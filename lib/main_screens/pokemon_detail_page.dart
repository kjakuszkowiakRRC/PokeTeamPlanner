import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poke_team_planner/universal/poke_app_bar.dart';
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
  late Future<List<Ability>> futureAbilities;

  // Future<List<Ability>> fetchAbilities(String abilities) async {
  //
  //
  //   final response = await http
  //   // .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/?limit=3'));
  //       .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/?limit=1'));
  //   if (response.statusCode == 200) {
  //     // Map firstMap = json.decode(response.body);
  //     // List jsonResponse = firstMap["results"];
  //     // List<Pokemon> pokemonList = jsonResponse
  //     //     .map((pokemon) => new Pokemon.fromJson(pokemon))
  //     //     .toList();
  //     // for(Pokemon pokemon in pokemonList) {
  //     //   // print(pokemon.url);
  //     //   final responsePokemonDetails = await http
  //     //       .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/${pokemon.name}'));
  //     //   // Map firstMap = json.decode(responsePokemonDetails.body);
  //     //   // List jsonResponse = firstMap;
  //     //   // List<Pokemon> test = jsonResponse
  //     //   //     .map((pokemon) => new Pokemon.fromJson(pokemon))
  //     //   //     .toList();
  //     //   // Map firstMap = json.decode(responsePokemonDetails.body);
  //     //   PokemonDetails pokemonDetails = new PokemonDetails.fromJson(jsonDecode(responsePokemonDetails.body));
  //     //   pokemon.pokemonDetails = pokemonDetails;
  //     //   // print(pokemon.pokemonDetails!.imageURL);
  //     // }
  //     List<Pokemon> pokemonList = [];
  //     int listSize = 9;
  //     // final snackBar = SnackBar(content: Text("HELLO"));
  //     // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     for(var i = 0; i < listSize; i++) {
  //       // print(pokemon.url);
  //       // print("BEFORE");
  //       final pokemonResponse = await http
  //           .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/${i+1}'));
  //       // print("HELLO");
  //       if(pokemonResponse.statusCode == 200) {
  //         // print("MORE FIRST");
  //         Pokemon pokemon = new Pokemon.fromJson(jsonDecode(pokemonResponse.body));
  //
  //         final pokedexEntryResponse = await http
  //             .get(Uri.parse('https://pokeapi.co/api/v2/pokemon-species/${pokemon.name}'));
  //
  //         if (response.statusCode == 200) {
  //           pokemon.pokedexEntry = jsonDecode(pokedexEntryResponse.body)['flavor_text_entries'][0]['flavor_text'];
  //           // print(jsonDecode(pokedexEntryResponse.body)['flavor_text_entries'][0]['flavor_text']);
  //         }
  //         else {
  //           throw Exception('Failed to load Pokedex entry');
  //         }
  //         // print("FIRST");
  //         pokemonList.add(pokemon);
  //         // print("SECOND");
  //         // print(pokemon.abilities);
  //         // print("THIRD");
  //       }
  //       else {
  //         throw Exception('Failed to load Pokemon');
  //       }
  //       // Map firstMap = json.decode(responsePokemonDetails.body);
  //       // List jsonResponse = firstMap;
  //       // List<Pokemon> test = jsonResponse
  //       //     .map((pokemon) => new Pokemon.fromJson(pokemon))
  //       //     .toList();
  //       // Map firstMap = json.decode(responsePokemonDetails.body);
  //       // PokemonDetails pokemonDetails = new PokemonDetails.fromJson(jsonDecode(pokemonResponse.body));
  //       // pokemon.pokemonDetails = pokemonDetails;
  //       // print(pokemon.pokemonDetails!.imageURL);
  //     }
  //     return pokemonList;
  //   } else {
  //     throw Exception('Failed to load Pokemon');
  //   }
  // }

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
                  // FutureBuilder(
                  //   future: futureAbilities,
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasData) {
                  //
                  //     }
                  //   }
                  // ),
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