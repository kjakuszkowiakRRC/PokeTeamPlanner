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

class Pokedex extends StatefulWidget {
  const Pokedex({Key? key}) : super(key: key);

  @override
  State<Pokedex> createState() => _PokedexState();
}

class _PokedexState extends State<Pokedex> {
  late Future<List<Pokemon>> futurePokemon;

  // Future<List<Pokemon>> fetchPokemon() async {
  //   final response = await http
  //       .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/?limit=898'));
  //   // .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/?limit=20'));
  //   // final jobsListAPIUrl = 'https://pokeapi.co/api/v2/pokemon/';
  //   // final response = await http.get(Uri.parse(jobsListAPIUrl));
  //   //
  //   // if (response.statusCode == 200) {
  //   //   // If the server did return a 200 OK response,
  //   //   // then parse the JSON.
  //   //   return Pokemon.fromJson(jsonDecode(response.body));
  //   // } else {
  //   //   // If the server did not return a 200 OK response,
  //   //   // then throw an exception.
  //   //   throw Exception('Failed to load Pokemon');
  //   // }
  //
  //   // List<dynamic> parsedListJson = jsonDecode("https://pokeapi.co/api/v2/pokemon");
  //   // List<Pokemon> pokemonList = List<Pokemon>.from(parsedListJson.map((i) => Pokemon.fromJson(i)));
  //
  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     Map firstMap = json.decode(response.body);
  //     // List jsonResponse = firstMap["results"];
  //     List jsonResponse = firstMap["results"];
  //     // List<Pokemon> jsonResponseTEST = firstMap["results"];
  //     // List<Pokemon> ints = List<Pokemon>.from(firstMap);
  //     // List<Pokemon> list = List<Pokemon>.from(firstMap.map((i) => Pokemon.fromJson(i)));
  //     // List<Pokemon>.from(jsonResponse.where((i) => i.flag == true));
  //     // final snackBar = SnackBar(content: Text(jsonResponse.length.toString() + " / " + jsonResponseTEST.length.toString()));
  //     // final snackBar = SnackBar(content: Text(jsonResponse.length.toString()));
  //     // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     // List jsonResponseTest = jsonResponse.last();
  //     return jsonResponse
  //         .map((pokemon) => new Pokemon.fromJson(pokemon))
  //         .toList();
  //     // return jsonResponseTEST;
  //     // return jsonResponse;
  //     // return pokemonList;
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load Pokemon');
  //   }
  // }

  Future<List<Pokemon>> fetchPokemon() async {
    final response = await http
        // .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/?limit=3'));
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/?limit=151'));
    if (response.statusCode == 200) {
      Map firstMap = json.decode(response.body);
      List jsonResponse = firstMap["results"];
      List<Pokemon> pokemonList = jsonResponse
          .map((pokemon) => new Pokemon.fromJson(pokemon))
          .toList();
      for(Pokemon pokemon in pokemonList) {
        // print(pokemon.url);
        final responsePokemonDetails = await http
            .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/${pokemon.name}'));
        // Map firstMap = json.decode(responsePokemonDetails.body);
        // List jsonResponse = firstMap;
        // List<Pokemon> test = jsonResponse
        //     .map((pokemon) => new Pokemon.fromJson(pokemon))
        //     .toList();
        // Map firstMap = json.decode(responsePokemonDetails.body);
        PokemonDetails pokemonDetails = new PokemonDetails.fromJson(jsonDecode(responsePokemonDetails.body));
        pokemon.pokemonDetails = pokemonDetails;
        // print(pokemon.pokemonDetails!.imageURL);
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
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return PokemonDetails.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
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
                  // List<dynamic> parsedListJson = jsonDecode("https://pokeapi.co/api/v2/pokemon");
                  // List<Pokemon> itemsList = snapshot.data;
                  if (snapshot.hasData) {
                    // final snackBar = SnackBar(content: Text(snapshot.data!.first.name));
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    // // List<Pokemon>? itemsList = snapshot.data;
                    // final snackBar2 = SnackBar(content: Text("TEEEEST"));
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar2);
                    // return Wrap(children: _jobsListView(snapshot.data));
                    // return Flexible(
                    //   flex: 1,
                    //     child: new Container(
                    //         child:
                    //           ListView.builder(
                    //               scrollDirection: Axis.vertical,
                    //               shrinkWrap: true,
                    //               itemCount: snapshot.data!.length,
                    //               itemBuilder: (context, index) {
                    //                 return _tile(index, snapshot.data![index].name, Icons.work);
                    //               })
                    //       )
                    //     );
                    return Flexible(
                        flex: 1,
                        child:
                            new Container(
                                child: _jobsListView(snapshot.data)
                            )
                    );
                    // return Text(snapshot.data);
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
    // fetchPokemonDetails(url);
    // final snackBar = SnackBar(content: Text("HELLO"));
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
      // subtitle: Text(pokemonDetails.),
      // subtitle: Text(subtitle),
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

  // Container _tile(int index, String title, Future<PokemonDetails> pokemonDetails, IconData icon) {
  //   return Container(
  //     children: [
  //       FutureBuilder(builder: builder)
  //       ListTile(
  //         title: Text("${index + 1}. ${title.toTitleCase()}",
  //             style: TextStyle(
  //               fontWeight: FontWeight.w500,
  //               fontSize: 20,
  //             )
  //         ),
  //         // subtitle: Text(pokemonDetails.),
  //         // subtitle: Text(subtitle),
  //         leading: Icon(
  //           icon,
  //           color: Colors.blue[500],
  //         ),
  //         onTap: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => PokemonDetailPage(),
  //             ),
  //           );
  //         },
  //
  //       ),
  //     ],
  //   );
  // }
  // FutureBuilder<Pokemon>(
  // future: pokemonDetails,
  // builder: (context, snapshot),
}
