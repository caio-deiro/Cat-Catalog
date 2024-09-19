// ignore_for_file: public_member_api_docs, sort_constructors_first

class CatEntitie {
  final String name;
  final String id;
  final String url;
  final String description;
  final String origin;
  final String life_span;
  final String temperament;
  final int adaptability;
  final int child_friendly;
  final int dog_friendly;
  final int energy_level;
  final int intelligence;
  final int stranger_friendly;
  final int affection_level;

  const CatEntitie({
    required this.name,
    required this.id,
    required this.url,
    required this.description,
    required this.origin,
    required this.life_span,
    required this.temperament,
    required this.adaptability,
    required this.child_friendly,
    required this.dog_friendly,
    required this.energy_level,
    required this.intelligence,
    required this.stranger_friendly,
    required this.affection_level,
  });

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CatEntitie && other.name == name;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode =>
      name.hashCode ^
      id.hashCode ^
      url.hashCode ^
      description.hashCode ^
      origin.hashCode ^
      life_span.hashCode ^
      temperament.hashCode ^
      adaptability.hashCode ^
      child_friendly.hashCode ^
      dog_friendly.hashCode ^
      energy_level.hashCode ^
      intelligence.hashCode ^
      stranger_friendly.hashCode ^
      affection_level.hashCode;
}
