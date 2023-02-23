import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DialogBox extends StatelessWidget {
  const DialogBox(
      {Key? key,
      required this.iconPath,
      required this.children,
      required this.buttonText,
      required this.onPressed,
      required this.title})
      : super(key: key);

  final String title;
  final String iconPath;
  final List<Widget> children;
  final String buttonText;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 28),
            padding:
                const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 30),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(0.7),
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  children: children,
                ),
                const SizedBox(
                  height: 22,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTapDown: (details) => onPressed(),
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF465770),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          buttonText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              radius: 28,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                child: SvgPicture.asset(
                  iconPath,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.onSecondaryContainer,
                      BlendMode.srcIn),
                  width: 35,
                  height: 35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
