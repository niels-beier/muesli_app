class ExerciseResult {
  double points;

  ExerciseResult({required this.points});

  factory ExerciseResult.fromJson(Map<String, dynamic> json) {
    return ExerciseResult(
      points: json['points'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'ExerciseResult{points: $points}';
  }
}
