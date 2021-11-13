import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poke_team_planner/universal/poke_app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:poke_team_planner/utils/pokemon.dart';

class Pokedex extends StatefulWidget {
  const Pokedex({Key? key}) : super(key: key);

  @override
  State<Pokedex> createState() => _PokedexState();
}

class _PokedexState extends State<Pokedex> {
  late Future<List<Pokemon>> futurePokemon;

  Future<List<Pokemon>> fetchPokemon() async {
    final response = await http
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/?limit=1118'));
        // .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/?limit=2'));
    // final jobsListAPIUrl = 'https://pokeapi.co/api/v2/pokemon/';
    // final response = await http.get(Uri.parse(jobsListAPIUrl));
    //
    // if (response.statusCode == 200) {
    //   // If the server did return a 200 OK response,
    //   // then parse the JSON.
    //   return Pokemon.fromJson(jsonDecode(response.body));
    // } else {
    //   // If the server did not return a 200 OK response,
    //   // then throw an exception.
    //   throw Exception('Failed to load Pokemon');
    // }

    // List<dynamic> parsedListJson = jsonDecode("https://pokeapi.co/api/v2/pokemon");
    // List<Pokemon> pokemonList = List<Pokemon>.from(parsedListJson.map((i) => Pokemon.fromJson(i)));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map firstMap = json.decode(response.body);
      // List jsonResponse = firstMap["results"];
      List jsonResponse = firstMap["results"];
      // List<Pokemon> jsonResponseTEST = firstMap["results"];
      // List<Pokemon> ints = List<Pokemon>.from(firstMap);
      // List<Pokemon> list = List<Pokemon>.from(firstMap.map((i) => Pokemon.fromJson(i)));
      // List<Pokemon>.from(jsonResponse.where((i) => i.flag == true));
      // final snackBar = SnackBar(content: Text(jsonResponse.length.toString() + " / " + jsonResponseTEST.length.toString()));
      // final snackBar = SnackBar(content: Text(jsonResponse.length.toString()));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // List jsonResponseTest = jsonResponse.last();
      return jsonResponse.map((pokemon) => new Pokemon.fromJson(pokemon)).toList();
      // return jsonResponseTEST;
      // return jsonResponse;
      // return pokemonList;
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
                    return _jobsListView(snapshot.data);
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
    // final snackBar = SnackBar(content: Text("HELLO"));
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index].name, Icons.work);
        });
  }

  ListTile _tile(String title, IconData icon) => ListTile(
    title: Text(title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    // subtitle: Text(subtitle),
    leading: Icon(
      icon,
      color: Colors.blue[500],
    ),
  );
}
