import 'package:flutter/material.dart';
import 'package:muesli_app/storage/storage.dart';

class MuesliAppBar extends StatelessWidget {
  MuesliAppBar({Key? key, required this.children}) : super(key: key);

  final List<Widget> children;
  final SecureStorage secureStorage = SecureStorage();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children,
          ),
        ),
        Divider(
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ],
    );
  }
}
