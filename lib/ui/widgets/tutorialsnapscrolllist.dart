import 'package:flutter/material.dart';
import 'package:muesli_app/model/tutorial.dart';
import 'package:muesli_app/ui/widgets/examlist.dart';
import 'dart:io' show Platform;

import 'package:scroll_snap_list/scroll_snap_list.dart';

// ignore: must_be_immutable
class TutorialScrollSnapList extends StatefulWidget {
  TutorialScrollSnapList(
      {Key? key,
      required this.buildItemList,
      required this.itemCount,
      required this.tutorialData, required this.noDataWidget})
      : super(key: key);

  final Widget Function(BuildContext, int) buildItemList;
  final int itemCount;
  final List<Tutorial> tutorialData;
  final Widget noDataWidget;

  int _selectedIndex = 0;

  @override
  State<TutorialScrollSnapList> createState() => _TutorialScrollSnapListState();
}

class _TutorialScrollSnapListState extends State<TutorialScrollSnapList> {
  final List<double> _percentages = [];
  final List<double> _maxPoints = [];
  final List<double> _points = [];

  @override
  void initState() {
    super.initState();
    for (var tutorial in widget.tutorialData) {
      double maxPoints = 0;
      double points = 0;
      for (var exam in tutorial.exams) {
        for (var exercise in exam.exercises.exercises) {
          maxPoints += exercise.maxPoints;
          points += exercise.exerciseResult.points;
        }
      }
      _percentages
          .add(maxPoints != 0 && !maxPoints.isNaN ? points / maxPoints : 0);
      _maxPoints.add(maxPoints);
      _points.add(points);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.tutorialData.isNotEmpty
        ? Column(
            children: [
              SizedBox(
                height: 170,
                child: ScrollSnapList(
                  itemBuilder: widget.buildItemList,
                  itemSize: 340,
                  onReachEnd: () {},
                  itemCount: widget.itemCount,
                  scrollPhysics:
                      Platform.isIOS ? const BouncingScrollPhysics() : null,
                  onItemFocus: (current) {
                    setState(() {
                      widget._selectedIndex = current;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 260,
                child: Divider(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 10),
              ExamList(
                exams: widget.tutorialData[widget._selectedIndex].exams,
                percentage: _percentages[widget._selectedIndex],
                maxPoints: _maxPoints[widget._selectedIndex],
                points: _points[widget._selectedIndex],
              ),
            ],
          )
        : widget.noDataWidget;
  }
}
