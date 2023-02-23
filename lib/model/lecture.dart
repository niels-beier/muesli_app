import 'package:muesli_app/model/user.dart';

class Lecture {
  int id;
  String name;
  String term;
  String lecturer;
  List<User> assistants;
  String url;

  Lecture(
      {required this.id,
      required this.name,
      required this.term,
      required this.lecturer,
      required this.assistants,
      required this.url});
}
