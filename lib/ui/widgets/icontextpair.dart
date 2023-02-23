import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconTextPair extends StatelessWidget {
  const IconTextPair(
      {Key? key,
      required this.iconPath,
      required this.text,
      this.direction = Axis.horizontal})
      : super(key: key);

  final String iconPath;
  final String text;
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: direction,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      children: [
        SvgPicture.asset(
          iconPath,
          colorFilter: ColorFilter.mode(
              Theme.of(context)
                  .colorScheme
                  .onSecondaryContainer
                  .withOpacity(0.8),
              BlendMode.srcIn),
          width: 25,
          height: 25,
        ),
        Text(text,
            style: TextStyle(
                fontSize: 16,
                fontFamily: "Inter",
                fontWeight: FontWeight.bold,
                color: Theme.of(context)
                    .colorScheme
                    .onSecondaryContainer
                    .withOpacity(0.8))),
      ],
    );
  }
}
