import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poke_team_planner/main_screens/pokemon_detail_page.dart';
import 'package:poke_team_planner/universal/pokemon_type_row.dart';
import 'package:poke_team_planner/utils/pokemon.dart';
import 'package:poke_team_planner/utils/string_extension.dart';

class PokedexEntry extends StatelessWidget {
  final Pokemon pokemon;
  final bool isFromPokedexPage;
  // final int position;

  const PokedexEntry(
      this.pokemon,
      this.isFromPokedexPage,
      {
      // this.position, {
        Key? key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Color(0xFF7F7F7F)),
            left: BorderSide(width: 1.0, color: Color(0xFF7F7F7F)),
            right: BorderSide(width: 1.0, color: Color(0xFF7F7F7F)),
            bottom: BorderSide(width: 1.0, color: Color(0xFF7F7F7F)),
          ),
          color: Color(0xFFFFFFF),
        //0xFFBFBFBF
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 35.0),
        child: GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PokemonDetailPage(pokemonObject: pokemon, isFromPokedex: isFromPokedexPage,),
                ),
              );
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // stopping this so i dont get blocked
                Image.network(pokemon.spriteURL),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("${pokemon.id}. ${pokemon.name.toTitleCase()}",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            )
                        )
                      ],
                    ),
                    Row(
                      children: [
                        PokemonTypeRow(pokemon.typesImageURL, isFromPokedexPage)
                      ],
                    )
                  ],
                ),
                // if (!isFromPokedexPage) IconButton(
                //   icon: const Icon(Icons.clear),
                //   tooltip: 'Remove from team',
                //   onPressed: () {
                //     // setState(() {
                //     //
                //     // });
                //   },
                // ),
                // Text('Volume : $_volume')
              ],
            )
        ),
      ),
    );
  }
}