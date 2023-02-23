import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:muesli_app/services/request.dart';
import 'package:muesli_app/storage/storage.dart';
import 'package:muesli_app/model/tutorial.dart' as models;
import 'package:muesli_app/ui/widgets/tutorial.dart' as widgets;
import 'package:muesli_app/ui/widgets/tutorialsnapscrolllist.dart';

class TutorialPage extends StatefulWidget {
  TutorialPage({Key? key}) : super(key: key);

  final SecureStorage secureStorage = SecureStorage();

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late Widget _tutorials;

  @override
  void initState() {
    super.initState();

    _tutorials = FutureBuilder<List<models.Tutorial>>(
      future: HttpRequest.getTutorialList(),
      builder: (context, AsyncSnapshot<List<models.Tutorial>> snapshot) {
        if (snapshot.hasData) {
          tutorialData = snapshot.data!;
          return TutorialScrollSnapList(
              itemCount: tutorialData.length,
              buildItemList: (context, index) => _buildItemList(context, index),
              tutorialData: tutorialData,
              noDataWidget: Container());
        }
        return LoadingAnimationWidget.fourRotatingDots(
            color: Theme.of(context).colorScheme.onBackground, size: 45);
      },
    );
  }

  List<models.Tutorial> tutorialData = [];

  Widget _buildItemList(BuildContext context, int index) {
    if (index == tutorialData.length) {
      return Center(
        child: LoadingAnimationWidget.fourRotatingDots(
            color: Theme.of(context).colorScheme.onBackground, size: 45),
      );
    }
    return SizedBox(
      width: 340,
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [widgets.Tutorial(tutorial: tutorialData[index])],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _tutorials;
  }
}
