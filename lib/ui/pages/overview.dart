import 'dart:math';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muesli_app/storage/storage.dart';
import 'package:muesli_app/ui/pages/lecture.dart';
import 'package:muesli_app/ui/pages/login.dart';
import 'package:muesli_app/ui/pages/tutorial.dart';
import 'package:muesli_app/ui/widgets/muesliappbar.dart';
import 'package:muesli_app/ui/widgets/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:muesli_app/services/globals.dart' as globals;

class OverviewPage extends StatefulWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  SecureStorage secureStorage = SecureStorage();
  int _currentPageIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        selectedIndex: _currentPageIndex,
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.book_outlined),
              selectedIcon: const Icon(Icons.book),
              label: AppLocalizations.of(context).tutorials_navbar),
          NavigationDestination(
              icon: const Icon(Icons.summarize_outlined),
              selectedIcon: const Icon(Icons.summarize),
              label: AppLocalizations.of(context).lectures_navbar),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            MuesliAppBar(
              children: [
                GestureDetector(
                  onTap: () {
                    secureStorage.deleteSecureData("token");
                    secureStorage.deleteSecureData("username");
                    secureStorage.deleteSecureData("password");
                    globals.prefs.remove("expireDate");

                    FLog.info(text: "Successcully logged out.");

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ));
                  },
                  child: Transform.rotate(
                    angle: pi,
                    child: SvgPicture.asset(
                      "assets/logout.svg",
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.onBackground,
                          BlendMode.srcIn),
                      width: 25,
                      height: 25,
                    ),
                  ),
                ),
                Text(
                  AppLocalizations.of(context).overview_header,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Inter",
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    FLog.info(text: "Open Settings Dialog.");
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => const Settings());
                  },
                  child: SvgPicture.asset(
                    "assets/settings.svg",
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.onBackground,
                        BlendMode.srcIn),
                    width: 25,
                    height: 25,
                  ),
                ),
              ],
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [TutorialPage(), const LecturePage()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
