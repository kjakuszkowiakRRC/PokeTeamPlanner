import 'package:flutter/material.dart';

class PokemonTypeRow extends StatelessWidget {
  // var pokemonTypeList;

  // PokemonTypeRow(typesImageURL, {
  //   this.pokemonTypeList = typesImageURL;
  // });

  var pokemonTypeList;
  bool isPokedexScreen;
  // final String message;

  PokemonTypeRow(
      this.pokemonTypeList,
      this.isPokedexScreen
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ..._buildTypeRowList(pokemonTypeList),
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
      abilities.add(SizedBox(width: 10));
    }
    if (typeList.length == 1) {
      abilities.add(SizedBox(width: 100));
      abilities.add(SizedBox(width: 10));
    }
    // print(isPokedexScreen.toString());
    if(isPokedexScreen) {
      abilities.add(Padding(child: Icon(Icons.zoom_in), padding: const EdgeInsets.only(left: 15.0),));
    }
    return abilities;
  }
}
