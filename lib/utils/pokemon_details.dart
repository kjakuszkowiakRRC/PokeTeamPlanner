//TODO: figure out type thing
class PokemonDetails {
  final int height;
  final int weight;
  // final List<String> types;
  final String imageURL;

  PokemonDetails({
    required this.height,
    required this.weight,
    // required this.types,
    required this.imageURL
  });

  factory PokemonDetails.fromJson(Map<String, dynamic> json) {
    return PokemonDetails(
      height: json['height'],
      weight: json['weight'],
      imageURL: json['sprites']['front_default'],
    );
  }
}