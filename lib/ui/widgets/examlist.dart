import 'package:flutter/material.dart';
import 'package:muesli_app/model/exam.dart';
import 'package:muesli_app/ui/widgets/card.dart' as widgets;
import 'package:muesli_app/ui/widgets/exam.dart' as widgets;
import 'package:muesli_app/ui/widgets/icontextpair.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExamList extends StatelessWidget {
  const ExamList(
      {Key? key,
      required this.exams,
      required this.percentage,
      this.maxPoints = 0,
      this.points = 0})
      : super(key: key);

  final List<Exam> exams;
  final double percentage;
  final double maxPoints;
  final double points;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: widgets.Card(
          color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.4),
          height: 500,
          child: Container(
            margin:
                const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            child: exams.isNotEmpty
                ? Column(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              value: percentage,
                              minHeight: 20,
                              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.6),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "$points/$maxPoints ${AppLocalizations.of(context).total_points_examlist} (${(percentage*100).toInt()}%)",
                              style: const TextStyle(
                                  color: Colors.white, fontFamily: "Inter", fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: exams
                                .map((exam) => widgets.Exam(exam: exam))
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: IconTextPair(
                      iconPath: "assets/sheet.svg",
                      text: AppLocalizations.of(context).no_exams_available,
                      direction: Axis.vertical,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
