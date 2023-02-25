import 'package:muesli_app/model/exerciselist.dart';

class Exam {
  int id;
  String name;
  String url;
  ExerciseList exercises;

  Exam({required this.id, required this.name, required this.url, required this.exercises});

  @override String toString() {
    return 'Exam{id: $id, name: $name, url: $url, exercises: ${exercises.toString()}}';
  }
}
