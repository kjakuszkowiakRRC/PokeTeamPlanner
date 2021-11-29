// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_team.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PokemonTeamAdapter extends TypeAdapter<PokemonTeam> {
  @override
  final int typeId = 0;

  @override
  PokemonTeam read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PokemonTeam()
      ..name = fields[0] as String
      ..pokemonTeam = (fields[1] as Map).cast<dynamic, dynamic>()
      ..pokemonTeamTypes = (fields[2] as List).cast<dynamic>()
      ..userID = fields[3] as String;
  }

  @override
  void write(BinaryWriter writer, PokemonTeam obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.pokemonTeam)
      ..writeByte(2)
      ..write(obj.pokemonTeamTypes)
      ..writeByte(3)
      ..write(obj.userID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonTeamAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
