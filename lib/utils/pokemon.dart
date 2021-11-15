import 'package:poke_team_planner/utils/string_extension.dart';

class Pokemon {
  final String name;
  final int height;
  final int weight;
  final String spriteURL;
  final String shinySpriteURL;
  final List<Ability> abilities;
  final List<Type> types;
  String? pokedexEntry;

  // final String url;
  // PokemonDetails? pokemonDetails;

//String get imageURL => imageurl here
  Pokemon({
    required this.name,
    required this.height,
    required this.weight,
    required this.spriteURL,
    required this.shinySpriteURL,
    required this.abilities,
    required this.types,
    this.pokedexEntry,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    var abilityList = json['abilities'] as List;
    // print(list.length);
    List<Ability> parsedAbilityList = abilityList.map((i) => Ability.fromJson(i)).toList();
    // print(dataList);
    var typeList = json['types'] as List;
    // print(list.length);
    List<Type> parsedTypeList = typeList.map((i) => Type.fromJson(i)).toList();
    // print(dataList);

    return Pokemon(
      name: json['name'],
      height: json['height'],
      weight: json['weight'],
      spriteURL: json['sprites']['front_default'],
      shinySpriteURL: json['sprites']['front_shiny'],
      abilities: parsedAbilityList,
      types: parsedTypeList,
    );
  }

  String getListContents(List list) {
    String listContents = "";

    for(var item in list) {
      listContents += item.name.toString() + "/";
    }
    listContents = listContents.substring(0, listContents.length-1);
    return listContents;
  }

  String getHeight() {
    // double formattedHeight = height;
    String formattedHeight = "";

    if(height > 10) {
      formattedHeight = '${(height / 10).toString()}m';
    }
    else {
      formattedHeight = '${(height * 10).toString()}cm';
    }
    return formattedHeight;
  }

  String getWeight() {
    return '${(weight / 10).toString()}kg';
  }

  String getPokedexEntry() {
    String formattedPokedexEntry= pokedexEntry!.replaceAll("\n", " ");
    return formattedPokedexEntry;
  }
}

class Ability {
  final String name;
  String? description;

  Ability({
    required this.name,
    this.description
  });

  factory Ability.fromJson(Map<String, dynamic> json) {
    // print(json);

    return Ability(
      name: json['ability']['name'],
    );
  }
}

class Type {
  final String name;

  Type({
    required this.name,
  });

  factory Type.fromJson(Map<String, dynamic> json) {
    // print(json);

    return Type(
      name: json['type']['name'],
    );
  }
}