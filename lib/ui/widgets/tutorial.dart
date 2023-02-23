import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:muesli_app/model/tutorial.dart' as models;
import 'package:muesli_app/ui/widgets/card.dart' as widget;
import 'package:muesli_app/ui/widgets/icontextpair.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Tutorial extends StatelessWidget {
  const Tutorial({Key? key, required this.tutorial}) : super(key: key);

  final models.Tutorial tutorial;

  @override
  Widget build(BuildContext context) {
    return widget.Card(
      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.4),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: AutoSizeText(
                tutorial.name,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Inter",
                  color: Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.8),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                direction: Axis.vertical,
                children: [
                  IconTextPair(
                      iconPath: "assets/time.svg",
                      text: "${tutorial.time} ${AppLocalizations.of(context).o_clock_tutorial}"),
                  IconTextPair(
                      iconPath: "assets/person.svg",
                      text:
                          "${tutorial.tutor.name} ${tutorial.tutor.lastName}"),
                  IconTextPair(
                      iconPath: "assets/place.svg", text: tutorial.place.length > 30 ? "${tutorial.place.substring(0, 30)}..." : tutorial.place),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
