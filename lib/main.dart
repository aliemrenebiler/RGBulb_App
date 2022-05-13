import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/connectscreen.dart';
import 'screens/controlscreen.dart';

void main() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RGBulb | Control Your Light',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      home: null, // <============================= DEĞİŞECEK
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/connectscreen':
            return PageTransition(
              child: const ConnectScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
          case '/controlscreen':
            return PageTransition(
              child: const ControlScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
          default:
            return PageTransition(
              child: const ConnectScreen(),
              type: PageTransitionType.fade,
              settings: settings,
            );
        }
      },
    );
  }
}
