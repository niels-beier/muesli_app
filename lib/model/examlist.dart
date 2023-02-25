import 'package:muesli_app/model/exam.dart';

class ExamList {
  List<Exam> exams;

  ExamList({required this.exams});

  Future<ExamList> fromJson(List<dynamic> json) async {
    for (var exam in json) {
      exams.add(await exam.fromJson(exam));
    }
    return ExamList(exams: exams);
  }

  @override
  String toString() {
    String result = 'ExamList:';
    for (Exam exam in exams) {
      result += '\n\t${exam.toString()}';
    }
    return result;
  }

  void add(Exam exam) {
    exams.add(exam);
  }
}
