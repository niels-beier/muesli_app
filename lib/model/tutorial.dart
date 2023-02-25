import 'package:muesli_app/model/user.dart';
import 'package:muesli_app/model/exam.dart';

class Tutorial {
  int id;
  int lectureId;
  String name;
  User tutor;
  String place;
  String time;
  List<Exam> exams;

  Tutorial({
    required this.id,
    required this.lectureId,
    required this.name,
    required this.tutor,
    required this.place,
    required this.time,
    required this.exams,
  });

  @override
  String toString() {
    return 'Tutorial{id: $id, lectureId: $lectureId, name: $name, tutor: $tutor, place: $place, time: $time, exams: ${exams.toString()}}';
  }
}
