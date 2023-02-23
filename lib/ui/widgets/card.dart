import 'package:flutter/material.dart';

class Card extends StatelessWidget {
  const Card({Key? key, this.child, this.height = 170, required this.color}) : super(key: key);

  final Widget? child;

  final double height;

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: color,
      ),
      child: child,
    );
  }
}
