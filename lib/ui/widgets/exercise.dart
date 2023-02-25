import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:muesli_app/model/exercise.dart' as models;

class Exercise extends StatelessWidget {
  const Exercise({Key? key, required this.exercise}) : super(key: key);

  final models.Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      "${exercise.exerciseResult.points} / ${exercise.maxPoints}",
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: "Inter",
        color: Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.8),
      ),
    );
  }
}
