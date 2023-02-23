import 'package:muesli_app/model/tutorial.dart';

class TutorialList {
  List<Tutorial> tutorials;

  TutorialList({
    required this.tutorials,
  });

  factory TutorialList.fromJson(Map<String, dynamic> json) {
    return TutorialList(tutorials: json['tutorials']);
  }
}
