import 'package:app/authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/app_controller.dart';
import 'package:app/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Authentication.checkForAuth().then((isAuthenticated) {
    AnyFluroRouter.setupRouter();
    runApp(Anypay(isAuthenticated));
  });
  Firebase.initializeApp();
}

class Anypay extends StatelessWidget {
  Anypay(this.isAuthenticated);

  final bool isAuthenticated;

  @override
  Widget build(BuildContext context) {
    return AppController(builder: (context) {
      var theme;

      var lightTheme = ThemeData(
        primaryColorDark: Color(0xFF707070),
        primaryColorLight: Color(0xFF404040),
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSwatch().copyWith(
            background: AppController.white,
            secondary: AppController.blue,
            brightness: Brightness.light),
        fontFamily: 'Ubuntu',
      );

      var darkTheme = ThemeData(
        primaryColorDark: Color(0xffCCCCCC),
        primaryColorLight: Color(0xFFFFFFFF),
        colorScheme: ColorScheme.fromSwatch().copyWith(
            background: Color(0xff222222),
            secondary: Color(0xff2196f3),
            brightness: Brightness.dark),
        brightness: Brightness.dark,
        fontFamily: 'Ubuntu',
      );

      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
      theme = lightTheme;

      if (AppController.enableDarkMode) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        theme = darkTheme;
      }

      return MaterialApp(
        builder: (BuildContext context, Widget? child) {
          if (child == null) {
            throw 'MaterialApp builder child is null';
          }

          return SafeArea(
            child: child,
          );
        },
        initialRoute: isAuthenticated ? 'new-invoice' : 'login',
        onGenerateRoute: AnyFluroRouter.router.generator,
        navigatorKey: AppController.globalKey,
        title: 'Anypay Cash Register',
        theme: theme,
      );
    });
  }
}
