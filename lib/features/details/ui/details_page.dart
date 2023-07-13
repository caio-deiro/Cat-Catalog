import 'package:cat_list/features/details/ui/widgets/animation_widget.dart';
import 'package:flutter/material.dart';

import '../../home/interactor/entitie/cat_entitie.dart';

class DetailsPage extends StatelessWidget {
  final CatEntitie cat;
  const DetailsPage({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Temperament :\n${cat.temperament}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    AnimationWidget(
                      catValue: cat.adaptability,
                      catTitle: 'Adaptability',
                    ),
                    AnimationWidget(
                      catValue: cat.affection_level,
                      catTitle: 'Affection Level',
                    ),
                    AnimationWidget(
                      catValue: cat.child_friendly,
                      catTitle: 'Child Friendly',
                    ),
                    AnimationWidget(
                      catValue: cat.dog_friendly,
                      catTitle: 'Dog Friendly',
                    ),
                    AnimationWidget(
                      catValue: cat.energy_level,
                      catTitle: 'Energy level',
                    ),
                    AnimationWidget(
                      catValue: cat.intelligence,
                      catTitle: 'Intelligence',
                    ),
                    AnimationWidget(
                      catValue: cat.stranger_friendly,
                      catTitle: 'Stranger Friendly',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
