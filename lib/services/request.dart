import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:muesli_app/services/exceptions.dart';
import 'package:muesli_app/storage/storage.dart';
import 'package:muesli_app/model/lecture.dart';
import 'package:muesli_app/model/tutorial.dart';
import 'package:muesli_app/model/exam.dart';
import 'package:muesli_app/model/exerciselist.dart';
import 'package:muesli_app/model/exerciseresultlist.dart';
import 'package:muesli_app/model/user.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:muesli_app/services/globals.dart' as globals;

const String apiUrl = "https://muesli.mathi.uni-heidelberg.de/api/v1";
const String className = "HttpRequest";

class HttpRequest {
  const HttpRequest();

  static Future<String> authenticate(String username, String password) async {
    try {
      final response = await http.post(Uri.parse("$apiUrl/login"), body: {
        "email": username,
        "password": password,
      });

      switch (response.statusCode) {
        case 200:
          Map<String, dynamic> json = jsonDecode(response.body);
          FLog.info(text: "Successfully authenticated.");
          return json["token"];
        case 404:
          throw NoServerConnectionException('Failed to connect to server');
        default:
          throw Exception(
              'Failed to authenticate\nError code: ${response.statusCode}');
      }
    } on SocketException {
      FLog.error(
          className: className,
          methodName: "authenticate",
          text: "Failed to connect to server.",
          stacktrace: StackTrace.current);
      throw NoServerConnectionException('Failed to connect to server.');
    }
  }

  static Future<User> getUserData() async {
    try {
      SecureStorage secureStorage = SecureStorage();
      final response = await http.get(Uri.parse("$apiUrl/whoami"), headers: {
        "Authorization":
            "Bearer ${await secureStorage.readSecureData('token')}",
      });

      if (response.statusCode == 200) {
        FLog.info(text: "Successfully requested user data.");
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to get user\nError code: ${response.statusCode}');
      }
    } on SocketException {
      FLog.error(
          className: className,
          methodName: "getUserData",
          text: "Failed to connect to server.",
          stacktrace: StackTrace.current);
      throw NoServerConnectionException('Failed to connect to server.');
    } catch (e) {
      FLog.error(
          className: className,
          methodName: "getUserData",
          text: "Exception occured:",
          exception: e,
          stacktrace: StackTrace.current);
          return User(id: 0, name: "", lastName: "", email: "");
    }
  }

  static Future<String> getLectureName(int id) async {
    try {
      SecureStorage secureStorage = SecureStorage();
      final response =
          await http.get(Uri.parse("$apiUrl/lectures/$id"), headers: {
        "Authorization":
            "Bearer ${await secureStorage.readSecureData('token')}",
      });

      if (response.statusCode == 200) {
        FLog.info(text: "Successfully requested lecture name.");
        Map<String, dynamic> json = jsonDecode(response.body);
        return json["lecture"]["name"];
      } else {
        throw Exception(
            'Failed to get lecture name\nError code: ${response.statusCode}');
      }
    } on SocketException {
      FLog.error(
          className: className,
          methodName: "getLectureName",
          text: "Failed to connect to server.",
          stacktrace: StackTrace.current);
      throw NoServerConnectionException('Failed to connect to server.');
    } catch (e) {
      FLog.error(
          className: className,
          methodName: "getLectureName",
          text: "Exception occured with lecture ID $id.",
          exception: e,
          stacktrace: StackTrace.current);
          return "";
    }
  }

  static Future<List<Tutorial>> getTutorialList() async {
    try {
      SecureStorage secureStorage = SecureStorage();
      final response = await http.get(Uri.parse("$apiUrl/tutorials"), headers: {
        "Authorization":
            "Bearer ${await secureStorage.readSecureData('token')}",
      });

      if (response.statusCode == 200) {
        FLog.info(text: "Successfully requested tutorials.");
        List<dynamic> json = jsonDecode(response.body);
        return await Future.wait(
            json.map((tutorial) => HttpRequest.getTutorial(tutorial['id'])));
      } else {
        throw Exception(
            'Failed to get tutorials\nError code: ${response.statusCode}');
      }
    } on SocketException {
      FLog.error(
          className: className,
          methodName: "getLectureList",
          text: "Failed to connect to server.",
          stacktrace: StackTrace.current);
      showSimpleNotification(
        Text(
          AppLocalizations.of(globals.context).no_connection_to_server,
          style: const TextStyle(fontFamily: "Inter"),
        ),
        background: const Color(0xFF465770),
        slideDismissDirection: DismissDirection.up,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      FLog.error(
          className: className,
          methodName: "getExam",
          text: "Exception occured.",
          exception: e,
          stacktrace: StackTrace.current);
    }
    return [];
  }

  static Future<List<Lecture>> getLectureList() async {
    try {
      SecureStorage secureStorage = SecureStorage();
      final response = await http.get(Uri.parse("$apiUrl/lectures"), headers: {
        "Authorization":
            "Bearer ${await secureStorage.readSecureData('token')}",
      });

      if (response.statusCode == 200) {
        FLog.info(text: "Successfully requested lectures.");
        List<dynamic> json = jsonDecode(response.body);
        List<Lecture> lectures = await Future.wait(
            json.map((lecture) => HttpRequest.getLecture(lecture['id'])));
        lectures.sort((a, b) => a.name.compareTo(b.name));
        return lectures;
      } else {
        throw Exception(
            'Failed to get lectures\nError code: ${response.statusCode}');
      }
    } on SocketException {
      FLog.error(
          className: className,
          methodName: "getLectureList",
          text: "Failed to connect to server.",
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
    } catch (e) {
      FLog.error(
          className: className,
          methodName: "getExam",
          text: "Exception occured.",
          exception: e,
          stacktrace: StackTrace.current);
    }
    return [];
  }

  static Future<Lecture> getLecture(int id) async {
    try {
      SecureStorage secureStorage = SecureStorage();
      final response =
          await http.get(Uri.parse("$apiUrl/lectures/$id"), headers: {
        "Authorization":
            "Bearer ${await secureStorage.readSecureData('token')}",
      });

      if (response.statusCode == 200) {
        FLog.info(text: "Successfully requested lecture.");
        Map<String, dynamic> json = jsonDecode(response.body);

        List<User> assistants = [];
        for (var assistant in json['lecture']['assistants']) {
          assistants.add(User(
            id: assistant['id'],
            name: "${assistant['title']} ${assistant['first_name']}",
            lastName: assistant['last_name'],
            email: assistant['email'],
          ));
        }

        return Lecture(
            id: json['lecture']['id'],
            name: json['lecture']['name'],
            term: json['lecture']['term'],
            lecturer: json['lecture']['lecturer'],
            assistants: assistants,
            url: json['lecture']['url'] == ""
                ? "Keine Webseite angegeben"
                : json['lecture']['url']);
      } else {
        throw Exception(
            'Failed to get lecture\nError code: ${response.statusCode}');
      }
    } on SocketException {
      FLog.error(
          className: className,
          methodName: "getLecture",
          text: "Failed to connect to server.",
          stacktrace: StackTrace.current);
      throw NoServerConnectionException('Failed to connect to server.');
    } catch (e) {
      FLog.error(
          className: className,
          methodName: "getLecture",
          text: "Exception occured with lecture ID $id.",
          exception: e,
          stacktrace: StackTrace.current);
      return Lecture(id: 0, name: "", term: "", lecturer: "", assistants: [], url: "");
    }
  }

  static Future<Tutorial> getTutorial(int id) async {
    try {
      SecureStorage secureStorage = SecureStorage();
      final response =
          await http.get(Uri.parse("$apiUrl/tutorials/$id"), headers: {
        "Authorization":
            "Bearer ${await secureStorage.readSecureData('token')}",
      });

      if (response.statusCode == 200) {
        FLog.info(text: "Successfully requested tutorial.");
        Map<String, dynamic> json = jsonDecode(response.body);
        var export = json['exams'] as List<dynamic>;
        var exams = await Future.wait(
            export.map((exam) => HttpRequest.getExam(exam['id'])));

        exams.sort((a, b) => a.id.compareTo(b.id));

        return Tutorial(
          id: json['id'],
          lectureId: json['lecture_id'],
          name: await HttpRequest.getLectureName(json['lecture_id']),
          tutor: json['tutor'] != null
              ? User.fromJson(json['tutor'])
              : User(id: 0, name: "User", lastName: "not provided", email: ""),
          place: json['place'],
          time: json['time'],
          exams: exams,
        );
      } else {
        throw Exception(
            'Failed to get lecture\nError code: ${response.statusCode}');
      }
    } on SocketException {
      FLog.error(
          className: className,
          methodName: "getTutorial",
          text: "Failed to connect to server.",
          stacktrace: StackTrace.current);
      throw NoServerConnectionException('Failed to connect to server.');
    } catch (e) {
      FLog.error(
          className: className,
          methodName: "getTutorial",
          text: "Exception occured with tutorial ID $id.",
          exception: e,
          stacktrace: StackTrace.current);
          return Tutorial(id: 0, lectureId: 0, name: "", tutor: User(id: 0, name: "", lastName: "", email: ""), place: "", time: "", exams: []);
    }
  }

  static Future<Exam> getExam(int id) async {
    try {
      SecureStorage secureStorage = SecureStorage();
      final response = await http.get(Uri.parse("$apiUrl/exams/$id"), headers: {
        "Authorization":
            "Bearer ${await secureStorage.readSecureData('token')}",
      });

      if (response.statusCode == 200) {
        FLog.info(text: "Successfully requested exam.");
        Map<String, dynamic> json = jsonDecode(response.body);
        return Exam(
          id: json['id'],
          name: json['name'],
          url: json['url'],
          exercises: await ExerciseList.fromJson(json['exercises']),
        );
      } else {
        throw Exception(
            'Failed to get exam\nError code: ${response.statusCode}');
      }
    } on SocketException {
      FLog.error(
          className: className,
          methodName: "getExam",
          text: "Failed to connect to server.",
          stacktrace: StackTrace.current);
      throw NoServerConnectionException('Failed to connect to server.');
    } catch (e) {
      FLog.error(
          className: className,
          methodName: "getExam",
          text: "Exception occured with exam ID $id.",
          exception: e,
          stacktrace: StackTrace.current);
      return Exam(id: 0, name: "", url: "", exercises: ExerciseList(exercises: []));
    }
  }

  static Future<ExerciseResultList> getExerciseResultList(int id) async {
    try {
      SecureStorage secureStorage = SecureStorage();
      final response = await http.get(
          Uri.parse(
              "$apiUrl/exercises/$id/${int.parse(await secureStorage.readSecureData('userId'))}"),
          headers: {
            "Authorization":
                "Bearer ${await secureStorage.readSecureData('token')}",
          });

      if (response.statusCode == 200) {
        FLog.info(text: "Successfully requested exercise results.");
        return ExerciseResultList.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to get exercise\nError code: ${response.statusCode}');
      }
    } on SocketException {
      FLog.error(
          className: className,
          methodName: "getExerciseResultList",
          text: "Failed to connect to server.",
          stacktrace: StackTrace.current);
      throw NoServerConnectionException('Failed to connect to server.');
    } catch (e) {
      FLog.error(
          className: className,
          methodName: "getExerciseResultList",
          text: "Exception occured with exercise results ID $id.",
          exception: e,
          stacktrace: StackTrace.current);
          return ExerciseResultList(exerciseResults: []);
    }
  }

  static launchURLBrowser(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      FLog.info(text: "Successfully launched url.");
    } else {
      FLog.warning(
          className: className,
          methodName: "launchURLBrowser",
          text: "Could not launch url $url.",
          stacktrace: StackTrace.current);
    }
  }
}
