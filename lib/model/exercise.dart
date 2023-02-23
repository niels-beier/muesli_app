import 'package:muesli_app/model/exerciseresult.dart';

class Exercise {
  int id;
  double maxPoints;
  int number;
  ExerciseResult exerciseResult;

  Exercise({
    required this.id,
    required this.maxPoints,
    required this.number,
    required this.exerciseResult,
  });

  static Exercise fromJson(Map<String, dynamic> json, ExerciseResult exerciseResult) {
    return Exercise(
      id: json["id"],
      maxPoints: json["maxpoints"],
      number: json["nr"],
      exerciseResult: exerciseResult,
    );
  }

  @override
  String toString() {
    return 'Exercise{id: $id, maxPoints: $maxPoints, number: $number, exerciseResultList: ${exerciseResult.toString()}}';
  }
}
