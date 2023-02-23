import 'package:muesli_app/model/exerciseresult.dart';

class ExerciseResultList {
  List<ExerciseResult> exerciseResults;

  ExerciseResultList({required this.exerciseResults});

  factory ExerciseResultList.fromJson(List<dynamic> json) {
    return ExerciseResultList(
      exerciseResults: json.map((e) => ExerciseResult.fromJson(e)).toList(),
    );
  }

  @override
  String toString() {
    String result = "ExerciseResultList:";
    for (ExerciseResult exerciseResult in exerciseResults) {
      result += "\n\t${exerciseResult.toString()}";
    }
    return result;
  }

  operator [](int index) => exerciseResults[index];
}
