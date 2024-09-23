// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AnimationWidget extends StatefulWidget {
  final int catValue;
  final String catTitle;
  const AnimationWidget({
    Key? key,
    required this.catValue,
    required this.catTitle,
  }) : super(key: key);

  @override
  State<AnimationWidget> createState() => _AnimationWidgetState();
}

class _AnimationWidgetState extends State<AnimationWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.catTitle} :',
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        TweenAnimationBuilder<double>(
          curve: Curves.ease,
          tween: Tween<double>(begin: 0, end: widget.catValue.toDouble() / 5),
          duration: const Duration(milliseconds: 2500),
          builder: (context, value, _) {
            return SizedBox(
              width: MediaQuery.of(context).size.width * .7,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: LinearProgressIndicator(
                  minHeight: 5,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.purple),
                  color: Colors.black87,
                  value: value,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
