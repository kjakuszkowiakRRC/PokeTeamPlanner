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
class Pokedex2 extends StatefulWidget {
  const Pokedex2({Key? key}) : super(key: key);

  @override
  State<Pokedex2> createState() => _PokedexState2();
}

class _PokedexState2 extends State<Pokedex2> {
  List<int> verticalData = [];
  late Future<List<Pokemon>> futurePokemon;
  late List pokemonTypeList;
  late List<Pokemon> pokemonList = [];

  final int increment = 10;
  int lazyListCounter = 0;

  bool isLoadingVertical = false;
  bool isLoadingHorizontal = false;

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
        .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/?limit=1'));
    if (response.statusCode == 200) {
      // Map firstMap = json.decode(response.body);
      // List jsonResponse = firstMap["results"];
      // List<Pokemon> pokemonList = jsonResponse
      //     .map((pokemon) => new Pokemon.fromJson(pokemon))
      //     .toList();
      // for(Pokemon pokemon in pokemonList) {
      //   // print(pokemon.url);
      //   final responsePokemonDetails = await http
      //       .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/${pokemon.name}'));
      //   // Map firstMap = json.decode(responsePokemonDetails.body);
      //   // List jsonResponse = firstMap;
      //   // List<Pokemon> test = jsonResponse
      //   //     .map((pokemon) => new Pokemon.fromJson(pokemon))
      //   //     .toList();
      //   // Map firstMap = json.decode(responsePokemonDetails.body);
      //   PokemonDetails pokemonDetails = new PokemonDetails.fromJson(jsonDecode(responsePokemonDetails.body));
      //   pokemon.pokemonDetails = pokemonDetails;
      //   // print(pokemon.pokemonDetails!.imageURL);
      // }
      List<Pokemon> pokemonList = [];
      int listSize = 12;
      // int listSize = 20;
      // final snackBar = SnackBar(content: Text("HELLO"));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      for(var i = 0; i < 20; i++) {
        // print(pokemon.url);
        // print("BEFORE");
        final pokemonResponse = await http
            .get(Uri.parse('https://pokeapi.co/api/v2/pokemon/${i+1}'));
        // print("HELLO");
        if(pokemonResponse.statusCode == 200) {
          // print("MORE FIRST");
          Pokemon pokemon = new Pokemon.fromJson(jsonDecode(pokemonResponse.body));

          final pokedexEntryResponse = await http
              .get(Uri.parse('https://pokeapi.co/api/v2/pokemon-species/${pokemon.name}'));

          if (response.statusCode == 200) {
            pokemon.pokedexEntry = jsonDecode(pokedexEntryResponse.body)['flavor_text_entries'][0]['flavor_text'];
              // print(jsonDecode(pokedexEntryResponse.body)['flavor_text_entries'][0]['flavor_text']);
          }
          else {
            throw Exception('Failed to load Pokedex entry');
          }

          // for(var ability in pokemon.abilities) {
          //
          //   final response = await http
          //       .get(Uri.parse('https://pokeapi.co/api/v2/ability/${ability.name}'));
          //   Map firstMap = json.decode(response.body);
          //   List jsonResponse = firstMap['effect_entries'];
          //   for (var key in jsonResponse){
          //     if(key['language']['name'] == 'en') {
          //       ability.description = key['effect'];
          //     }
          //
          //   }
          // }

          pokemon.typesImageURL = [];

          for(var pokemonType in pokemon.types) {

            // final response = await http
            //     .get(Uri.parse('https://pokeapi.co/api/v2/ability/${ability.name}'));
            // Map firstMap = json.decode(response.body);
            // List jsonResponse = firstMap['effect_entries'];
            for (var type in pokemonTypeList){
              if(type['name'] == pokemonType.name) {
                pokemon.typesImageURL!.add(type['image_path']);
              }

              // print(firstMap[key]);
            }
          }
          // print("FIRST");
          pokemonList.add(pokemon);
          // print("SECOND");
          // print(pokemon.abilities);
          // print("THIRD");
        }
        else {
          throw Exception('Failed to load Pokemon');
        }
        // Map firstMap = json.decode(responsePokemonDetails.body);
        // List jsonResponse = firstMap;
        // List<Pokemon> test = jsonResponse
        //     .map((pokemon) => new Pokemon.fromJson(pokemon))
        //     .toList();
        // Map firstMap = json.decode(responsePokemonDetails.body);
        // PokemonDetails pokemonDetails = new PokemonDetails.fromJson(jsonDecode(pokemonResponse.body));
        // pokemon.pokemonDetails = pokemonDetails;
        // print(pokemon.pokemonDetails!.imageURL);
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

  // @override
  // void initState() {
  //   super.initState();
  // }

  // Future<PokemonDetails> fetchPokemonDetails(String url) async {
  //   print(url);
  //   final response = await http
  //       .get(Uri.parse(url));
  //
  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     return PokemonDetails.fromJson(jsonDecode(response.body));
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load Pokemon');
  //   }
  // }

  @override
  void initState() {
    _loadMoreVertical();
    super.initState();
    // futurePokemon = fetchPokemon();
    this.loadJsonData();
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
    print("ENDING");
    pokemonList.addAll(
        List.generate(
            10, (index) => pokemonListFiller.elementAt(index)));
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
      appBar: PokeAppBar(),
      body: LazyLoadScrollView(
                isLoading: isLoadingVertical,
                onEndOfPage: () => _loadMoreVertical(),
                child: Scrollbar(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Vertical ListView',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: pokemonList.length,
                        itemBuilder: (context, position) {
                          pokemonList.elementAt(position);
                          return DemoItem(pokemonList.elementAt(position), position);
                        },
                      ),
                    ],
                  ),
                ),
              )
    );
  }

  // ListView _pokemonListView(data) {
  //   // fetchPokemonDetails(url);
  //   // final snackBar = SnackBar(content: Text("HELLO"));
  //   // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   return ListView.builder(
  //       scrollDirection: Axis.vertical,
  //       shrinkWrap: true,
  //       itemCount: data.length,
  //       itemBuilder: (context, index) {
  //         // return _tile(index, data[index].name, data[index]);
  //         return _pokedexEntry(index, data[index].name, data[index]);
  //       });
  // }

  ListTile _tile(int index, String title, Pokemon pokemon) {
    return ListTile(
      title: Text("${index + 1}. ${title.toTitleCase()}",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )
      ),
      subtitle: Text(pokemon.getListContents(pokemon.types)),
      // subtitle: AssetImage('assets/images/pokeball.png'),
      // subtitle: Text(subtitle),
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


class DemoItem extends StatelessWidget {
  final Pokemon pokemon;
  final int position;

  const DemoItem(
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

