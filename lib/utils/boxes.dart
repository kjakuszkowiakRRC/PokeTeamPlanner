import 'package:hive/hive.dart';
import 'package:poke_team_planner/utils/pokemon_team.dart';

class Boxes {
  static Box<PokemonTeam> getPokemonTeams() =>
      Hive.box<PokemonTeam>('pokemon_teams');
}