// ignore_for_file: use_build_context_synchronously

import 'package:f_logs/model/flog/flog.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:muesli_app/services/exceptions.dart';
import 'package:muesli_app/services/request.dart';
import 'package:muesli_app/storage/storage.dart';
import 'package:muesli_app/ui/pages/overview.dart';
import 'package:muesli_app/ui/widgets/muesliappbar.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String className = "LoginPage";

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // validate username is an email address
  bool _isUsernameValid(String username) {
    return RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
        .hasMatch(username);
  }

  bool _loading = false;

  void _login(BuildContext context) async {
    if (_isUsernameValid(_usernameController.text) &&
        !(_passwordController.text == "")) {
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() {
        _loading = true;
      });

      final secureStorage = SecureStorage();
      final prefs = await SharedPreferences.getInstance();
      secureStorage.writeSecureData("username", _usernameController.text);
      secureStorage.writeSecureData("password", _passwordController.text);
      String token;

      try {
        token = await HttpRequest.authenticate(
          await secureStorage.readSecureData("username"),
          await secureStorage.readSecureData("password"),
        );
        secureStorage.writeSecureData("token", token);

        final now = DateTime.now();

        prefs.setInt(
            "expireDate",
            DateTime(now.year, now.month, now.day + 29)
                .toUtc()
                .millisecondsSinceEpoch);

        setState(() {
          _loading = false;
        });

        secureStorage.writeSecureData(
            "userId", (await HttpRequest.getUserData()).id.toString());

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: ((context) => const OverviewPage())));
      } on NoServerConnectionException {
        setState(() {
          _loading = false;
        });

        showSimpleNotification(
          Text(
            AppLocalizations.of(context).no_connection_to_server,
            style: TextStyle(
                fontFamily: "Inter",
                color: Theme.of(context).colorScheme.onErrorContainer),
          ),
          background: Theme.of(context).colorScheme.errorContainer,
          slideDismissDirection: DismissDirection.up,
          duration: const Duration(seconds: 3),
        );
      } catch (e) {
        setState(() {
          _loading = false;
        });

        FLog.error(
            className: className,
            methodName: "_login",
            text: "Exception occured:",
            exception: e,
            stacktrace: StackTrace.current);
      }
    } else {
      FLog.info(text: "No email or password entered.");
      showSimpleNotification(
        Text(
          AppLocalizations.of(context).no_email_or_password_entered,
          style: TextStyle(
              fontFamily: "Inter",
              color: Theme.of(context).colorScheme.onErrorContainer),
        ),
        background: Theme.of(context).colorScheme.errorContainer,
        slideDismissDirection: DismissDirection.up,
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              children: [
                MuesliAppBar(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context).login,
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Inter"),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.asset("assets/cereal.png"),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context).login_description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AutofillGroup(
                          child: Column(
                            children: [
                              TextField(
                                controller: _usernameController,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                decoration: InputDecoration(
                                  labelText:
                                      AppLocalizations.of(context).email_login,
                                  labelStyle: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground)),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: _passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                autofillHints: const [AutofillHints.password],
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)
                                      .password_login,
                                  labelStyle: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTapDown: (details) => _login(context),
                          child: Container(
                            width: 125,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer
                                  .withOpacity(0.7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context).execute_login,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        _loading
            ? Container(
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.background.withOpacity(0.7),
                ),
                child: Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                      color: Theme.of(context).colorScheme.onBackground,
                      size: 45),
                ),
              )
            : Container(),
      ],
    );
  }
}
