import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:muesli_app/ui/pages/login.dart';
import 'package:muesli_app/ui/pages/overview.dart';
import 'package:muesli_app/services/globals.dart' as globals;
import 'package:muesli_app/storage/storage.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sdk_int/sdk_int.dart';
import 'package:shared_preferences/shared_preferences.dart';

final secureStorage = SecureStorage();
const className = "Main";
late bool tokenExpired;
late bool isDarkMode;

void logMetaData(bool isAndroid, AndroidDeviceInfo androidInfo, IosDeviceInfo iosInfo) async {
  FLog.info(className: "MetaInfo", text: "Platform: ${Platform.isAndroid ? "Android" : "iOS"}");
  FLog.info(className: "MetaInfo", text: "App Version: ${globals.packageInfo.version}");
  FLog.info(className: "MetaInfo", text: "System Version: ${isAndroid ? await SDKInt.currentSDKVersion : iosInfo.systemVersion}");
  FLog.info(className: "MetaInfo", text: "Manufacturer: ${isAndroid ? androidInfo.manufacturer : "Apple"}");
  FLog.info(className: "MetaInfo", text: "Model: ${isAndroid ? androidInfo.model : iosInfo.model}");
  FLog.info(className: "MetaInfo", text: "Physical device: ${isAndroid ? androidInfo.isPhysicalDevice : iosInfo.isPhysicalDevice}");
  FLog.info(className: "MetaInfo", text: "System Features: ${isAndroid ? androidInfo.systemFeatures : "Not available for iOS devices."}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final bool isAndroid = Platform.isAndroid;

  globals.prefs = await SharedPreferences.getInstance();

  globals.packageInfo = await PackageInfo.fromPlatform();

  final deviceInfoPlugin = DeviceInfoPlugin();
  final androidInfo = await deviceInfoPlugin.androidInfo;
  final iosInfo = await deviceInfoPlugin.iosInfo;

  LogsConfig config = LogsConfig()..formatType = FormatType.FORMAT_SQUARE;
  FLog.applyConfigurations(config);

  await FLog.clearLogs();
  FLog.info(className: className, text: "Cleared logs.");

  logMetaData(isAndroid, androidInfo, iosInfo);

  isDarkMode =
      SchedulerBinding.instance.window.platformBrightness == Brightness.dark &&
          await SDKInt.currentSDKVersion >= 29;

  FLog.info(
      className: className,
      methodName: "main",
      text: "isDarkMode: $isDarkMode");

  tokenExpired = globals.prefs.getInt("expireDate") != null
      ? DateTime.fromMillisecondsSinceEpoch(globals.prefs.getInt("expireDate")!)
          .isBefore(DateTime.now())
      : true;

  FLog.info(
      className: className,
      methodName: "main",
      text: "tokenExpired: $tokenExpired");

  FLog.info(
      className: className,
      text:
          "Dynamic Color enabled: ${await DynamicColorPlugin.getCorePalette() != null}");

  runApp(const MuesliApp());
}

class MuesliApp extends StatelessWidget {
  const MuesliApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    globals.context = context;

    // tell app to use fullscreen mode with rendering system ui like status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // set color of system navigation bar to transparent
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    // force portrait mode
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return OverlaySupport(
      child: DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) => MaterialApp(
          title: "Müsli",
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
              colorScheme: lightDynamic?.harmonized(), useMaterial3: true),
          darkTheme: ThemeData(
              colorScheme: darkDynamic?.harmonized(), useMaterial3: true),
          // ignore: unrelated_type_equality_checks
          home: tokenExpired ? const LoginPage() : const OverviewPage(),
        ),
      ),
    );
  }
}
