// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cat_list/features/home/interactor/entitie/cat_entitie.dart';
import 'package:flutter/material.dart';

class CatPage extends StatefulWidget {
  final CatEntitie cat;
  const CatPage({
    Key? key,
    required this.cat,
  }) : super(key: key);

  @override
  State<CatPage> createState() => _CatPageState();
}

class _CatPageState extends State<CatPage> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation colorAnimation;
  late Animation rotateAnimation;
  late Animation paddingAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    animationController.forward();
    colorAnimation = ColorTween(begin: Colors.transparent, end: Colors.black).animate(animationController);

    rotateAnimation = Tween<double>(begin: 4, end: 0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.decelerate,
      ),
    );

    paddingAnimation = Tween<double>(begin: 100, end: 30).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.decelerate,
      ),
    );

    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Hero(
                    tag: 'cat${widget.cat.id}',
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 350),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.network(
                            widget.cat.url,
                            errorBuilder: (context, error, stackTrace) => const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.pets),
                                SizedBox(height: 5),
                                Text('Image not found'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: paddingAnimation.value),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Text(
                              widget.cat.name,
                              style: TextStyle(
                                color: colorAnimation.value,
                                fontSize: 26,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              widget.cat.description,
                              style: TextStyle(color: colorAnimation.value),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Country of origin: ${widget.cat.origin}',
                              style: TextStyle(color: colorAnimation.value),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              'Lifetime: ${widget.cat.life_span}',
                              style: TextStyle(color: colorAnimation.value),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
