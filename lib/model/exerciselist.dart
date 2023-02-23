import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/material.dart';
import 'package:muesli_app/services/exceptions.dart';
import 'package:muesli_app/services/request.dart';
import 'package:muesli_app/model/exercise.dart';
import 'package:muesli_app/model/exerciseresultlist.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:muesli_app/services/globals.dart' as globals;

const String className = "ExerciseList";

class ExerciseList {
  List<Exercise> exercises;

  ExerciseList({required this.exercises});

  static Future<ExerciseList> fromJson(List<dynamic> json) async {
    try {
      if (json.isEmpty) {
        return ExerciseList(exercises: []);
      }
      List<Exercise> exercises = [];
      ExerciseResultList exerciseResultList =
          await HttpRequest.getExerciseResultList(json[0]['id']);
      if (exerciseResultList.exerciseResults.isNotEmpty) {
        for (int i = 0; i < exerciseResultList.exerciseResults.length; i++) {
          exercises.add(Exercise.fromJson(
              json[i], exerciseResultList.exerciseResults[i]));
        }
      }
      return ExerciseList(exercises: exercises);
    } on NoServerConnectionException {
      FLog.error(
          className: className,
          methodName: "fromJson",
          text: "No connection to server.",
          stacktrace: StackTrace.current);
      showSimpleNotification(
        Text(
          AppLocalizations.of(globals.context).no_connection_to_server,
          style: TextStyle(
              fontFamily: "Inter",
              color: Theme.of(globals.context).colorScheme.onErrorContainer),
        ),
        background: Theme.of(globals.context).colorScheme.errorContainer,
        slideDismissDirection: DismissDirection.up,
        duration: const Duration(seconds: 3),
      );
      return ExerciseList(exercises: []);
    }
  }

  @override
  String toString() {
    String result = "ExerciseList:";
    for (Exercise exercise in exercises) {
      result += "\n\t${exercise.toString()}";
    }
    return result;
  }

  void add(Exercise exercise) {
    exercises.add(exercise);
  }
}
