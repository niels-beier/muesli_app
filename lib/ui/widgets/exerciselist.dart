import 'package:flutter/cupertino.dart';
import 'package:muesli_app/model/exerciselist.dart' as models;
import 'package:muesli_app/ui/widgets/exercise.dart' as widgets;

class ExerciseList extends StatelessWidget {
  const ExerciseList({Key? key, required this.exercises}) : super(key: key);

  final models.ExerciseList exercises;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: exercises.exercises
            .map((exercise) => widgets.Exercise(exercise: exercise))
            .toList(),
      ),
    );
  }
}
