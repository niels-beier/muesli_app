// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/material.dart';
import 'package:muesli_app/services/request.dart';
import 'package:muesli_app/ui/widgets/dialogbox.dart';
import 'package:muesli_app/ui/widgets/settingsmenubutton.dart';
import 'package:muesli_app/services/globals.dart' as globals;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:overlay_support/overlay_support.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return DialogBox(
      title: AppLocalizations.of(context).settings,
      iconPath: "assets/settings.svg",
      onPressed: () => Navigator.pop(context),
      buttonText: AppLocalizations.of(context).save_settings,
      children: [
        Text(
          "${AppLocalizations.of(context).available_soon}:\n${AppLocalizations.of(context).notifications_new_lectures}",
          style: TextStyle(
              fontFamily: "Inter",
              color: Theme.of(context)
                  .colorScheme
                  .onSecondaryContainer
                  .withOpacity(0.8)),
        ),
        const SizedBox(height: 10),
        SettingsMenuButton(
          text: AppLocalizations.of(context).legal_notice_settings,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => LicensePage(
                    applicationName: AppLocalizations.of(context).app_name,
                    applicationVersion: globals.packageInfo.version,
                  )),
            ),
          ),
        ),
        SettingsMenuButton(
            text: AppLocalizations.of(context).github_settings,
            onTap: () {
              HttpRequest.launchURLBrowser(
                  "https://github.com/niels-beier/muesli_app");
            }),
        SettingsMenuButton(
            text:
                "${AppLocalizations.of(context).version_settings} ${globals.packageInfo.version}",
            onTap: () {}),
        SettingsMenuButton(
            text: AppLocalizations.of(context).export_logs_settings,
            onTap: () async {
              File exported = await FLog.exportLogs();
              if (Platform.isAndroid) {
                showSimpleNotification(
                    Text(
                        "${AppLocalizations.of(context).exported_logs_success} ${exported.path}"),
                    duration: const Duration(seconds: 5));
                FLog.info(text: "Exported logs.");
              } else {
                // TODO: Add share menu for exporting on iOS
              }
            }),
        SettingsMenuButton(
            text: AppLocalizations.of(context).privacy_settings,
            onTap: () {
              if (Platform.isAndroid) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(AppLocalizations.of(context).privacy_settings),
                    content: Text(AppLocalizations.of(context).privacy_content),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          "OK",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer),
                        ),
                      ),
                    ],
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                  ),
                );
              }
            }),
        const Divider(),
      ],
    );
  }
}
