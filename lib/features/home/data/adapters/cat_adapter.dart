import 'package:cat_list/features/home/interactor/entitie/cat_entitie.dart';

class CatAdapter {
  static CatEntitie fromJson(Map<String, dynamic> json) {
    return CatEntitie(
      name: json['breeds'][0]['name'],
      id: json['id'],
      url: json['url'],
      description: json['breeds'][0]['description'],
      origin: json['breeds'][0]['origin'],
      life_span: json['breeds'][0]['life_span'],
      adaptability: json['breeds'][0]['adaptability'] as int,
      affection_level: json['breeds'][0]['affection_level'] as int,
      child_friendly: json['breeds'][0]['child_friendly'] as int,
      dog_friendly: json['breeds'][0]['dog_friendly'] as int,
      energy_level: json['breeds'][0]['energy_level'] as int,
      intelligence: json['breeds'][0]['intelligence'] as int,
      stranger_friendly: json['breeds'][0]['stranger_friendly'] as int,
      temperament: json['breeds'][0]['temperament'],
    );
  }
}
