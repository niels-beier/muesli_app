import 'package:flutter/material.dart';

class SettingsMenuButton extends StatelessWidget {
  const SettingsMenuButton({Key? key, required this.text, required this.onTap})
      : super(key: key);

  final String text;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Column(
        children: [
          const Divider(),
          Text(text, style: const TextStyle(fontFamily: "Inter"),),
        ],
      ),
    );
  }
}
