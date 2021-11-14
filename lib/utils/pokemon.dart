import 'package:poke_team_planner/utils/pokemon_details.dart';

class Pokemon {
  final String name;
  final String url;
  PokemonDetails? pokemonDetails;

//String get imageURL => imageurl here
  Pokemon({
    required this.name,
    required this.url,
    this.pokemonDetails
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      url: json['url'],
    );
  }
}