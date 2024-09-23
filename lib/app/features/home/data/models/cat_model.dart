import 'package:cat_list/app/features/home/interactor/entitie/cat_entitie.dart';

final class CatModel extends CatEntitie {
  const CatModel({
    required String name,
    required String id,
    required String url,
    required String description,
    required String origin,
    required String lifeSpan,
    required String temperament,
    required int adaptability,
    required int childFriendly,
    required int dogFriendly,
    required int energyLevel,
    required int intelligence,
    required int strangerFriendly,
    required int affectionLevel,
  }) : super(
          child_friendly: childFriendly,
          dog_friendly: dogFriendly,
          adaptability: adaptability,
          energy_level: energyLevel,
          intelligence: intelligence,
          affection_level: affectionLevel,
          stranger_friendly: strangerFriendly,
          name: name,
          id: id,
          url: url,
          description: description,
          origin: origin,
          life_span: lifeSpan,
          temperament: temperament,
        );

  factory CatModel.fromJson(Map<String, dynamic> json) {
    return CatModel(
      name: json['breeds'][0]['name'],
      id: json['id'],
      url: json['url'],
      description: json['breeds'][0]['description'],
      origin: json['breeds'][0]['origin'],
      lifeSpan: json['breeds'][0]['life_span'],
      adaptability: json['breeds'][0]['adaptability'] as int,
      affectionLevel: json['breeds'][0]['affection_level'] as int,
      childFriendly: json['breeds'][0]['child_friendly'] as int,
      dogFriendly: json['breeds'][0]['dog_friendly'] as int,
      energyLevel: json['breeds'][0]['energy_level'] as int,
      intelligence: json['breeds'][0]['intelligence'] as int,
      strangerFriendly: json['breeds'][0]['stranger_friendly'] as int,
      temperament: json['breeds'][0]['temperament'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'url': url,
      'description': description,
      'origin': origin,
      'life_span': life_span,
      'temperament': temperament,
      'adaptability': adaptability,
      'child_friendly': child_friendly,
      'dog_friendly': dog_friendly,
      'energy_level': energy_level,
      'intelligence': intelligence,
      'stranger_friendly': stranger_friendly,
      'affection_level': affection_level,
    };
  }

  // @override
  // bool operator ==(Object other) {
  //   if (identical(this, other)) return true;

  //   return other is CatEntitie && other.name == name;
  // }

  // @override
  // int get hashCode =>
  //     name.hashCode ^
  //     id.hashCode ^
  //     url.hashCode ^
  //     description.hashCode ^
  //     origin.hashCode ^
  //     life_span.hashCode ^
  //     temperament.hashCode ^
  //     adaptability.hashCode ^
  //     child_friendly.hashCode ^
  //     dog_friendly.hashCode ^
  //     energy_level.hashCode ^
  //     intelligence.hashCode ^
  //     stranger_friendly.hashCode ^
  //     affection_level.hashCode;
}
