import 'package:f_logs/model/flog/flog.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:muesli_app/services/exceptions.dart';
import 'package:muesli_app/services/request.dart';
import 'package:muesli_app/model/lecture.dart' as models;
import 'package:muesli_app/ui/widgets/lecture.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:muesli_app/services/globals.dart' as globals;

const String className = "LecturePage";

class LecturePage extends StatefulWidget {
  const LecturePage({Key? key}) : super(key: key);

  @override
  State<LecturePage> createState() => _LecturePageState();
}

class _LecturePageState extends State<LecturePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<models.Lecture> lectureData = [];

  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    // use async call to get a build context during initState
    try {
      _lectures = FutureBuilder(
        future: HttpRequest.getLectureList(),
        builder: (context, AsyncSnapshot<List<models.Lecture>> snapshot) {
          if (snapshot.hasData) {
            lectureData = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(left: 14, right: 14, bottom: 14),
              child: FadingEdgeScrollView.fromSingleChildScrollView(
                child: SingleChildScrollView(
                  controller: _controller,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        child: ListView.builder(
                          itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Lecture(lecture: lectureData[index])),
                          itemCount: lectureData.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return LoadingAnimationWidget.fourRotatingDots(
                color: Theme.of(context).colorScheme.onBackground, size: 45);
          }
        },
      );
    } on NoServerConnectionException {
      _lectures = Container();
      FLog.error(
          className: className,
          methodName: "fromJson",
          text: "No connection to server.",
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
    }
  }

  late Widget _lectures;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _lectures;
  }
}
