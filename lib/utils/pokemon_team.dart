import 'package:poke_team_planner/utils/string_extension.dart';
import 'package:hive/hive.dart';

part 'pokemon_team.g.dart';

@HiveType(typeId: 0)
class PokemonTeam extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late Map pokemonTeam;

  @HiveField(2)
  late List pokemonTeamTypes;

  @HiveField(3)
  late String? userID;
  // final String url;
  // PokemonDetails? pokemonDetails;

//String get imageURL => imageurl here

}