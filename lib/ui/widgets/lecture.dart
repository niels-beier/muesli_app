import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:muesli_app/services/request.dart';
import 'package:muesli_app/model/lecture.dart' as models;
import 'package:muesli_app/ui/widgets/card.dart' as widget;
import 'package:muesli_app/ui/widgets/icontextpair.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Lecture extends StatelessWidget {
  const Lecture({Key? key, required this.lecture}) : super(key: key);

  final models.Lecture lecture;

  @override
  Widget build(BuildContext context) {
    List<String> assistants = [];
    lecture.assistants.map((assistant) {
      if (!lecture.lecturer.contains(assistant.lastName)) {
        assistants.add("${assistant.name} ${assistant.lastName}");
      }
    }).toList();

    return GestureDetector(
      onTap: () {
        HttpRequest.launchURLBrowser(lecture.url);
      },
      child: widget.Card(
        color:
            Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: AutoSizeText(
                  lecture.name,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Inter",
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer
                        .withOpacity(0.8),
                  ),
                ),
              ),
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  direction: Axis.vertical,
                  children: [
                    IconTextPair(
                        iconPath: "assets/time.svg", text: lecture.term),
                    IconTextPair(
                        iconPath: "assets/person.svg",
                        text: lecture.lecturer.isEmpty
                            ? AppLocalizations.of(context).no_lecturer_lecture
                            : lecture.lecturer.length < 40
                                ? lecture.lecturer
                                : "${lecture.lecturer.substring(0, 40)}..."),
                    IconTextPair(
                        iconPath: "assets/multi_person.svg",
                        text: assistants.isEmpty
                            ? AppLocalizations.of(context).no_assistants_lecture
                            : assistants.join(", ").length < 35
                                ? assistants.join(", ")
                                : "${assistants.join(", ").substring(0, 35)}..."),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
