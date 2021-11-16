import 'package:flutter/material.dart';

class PokemonTypeRow extends StatelessWidget {
  // var pokemonTypeList;

  // PokemonTypeRow(typesImageURL, {
  //   this.pokemonTypeList = typesImageURL;
  // });

  var pokemonTypeList;
  // final String message;

  PokemonTypeRow(this.pokemonTypeList);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
    }
    return abilities;
  }
}
