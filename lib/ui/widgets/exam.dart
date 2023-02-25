import 'package:flutter/material.dart';
import 'package:muesli_app/model/exam.dart' as models;
import 'package:muesli_app/ui/widgets/exerciselist.dart';

class Exam extends StatelessWidget {
  const Exam({Key? key, required this.exam}) : super(key: key);

  final models.Exam exam;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(exam.name.length > 20 ? "${exam.name.substring(0, 20)}..." : exam.name,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: "Inter",
                color: Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.8))),
        const SizedBox(
          width: 30,
        ),
        ExerciseList(exercises: exam.exercises),
      ],
    );
  }
}
