import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/connectscreen.dart';
import 'screens/controlscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        highlightColor: Colors.blue,
        splashFactory: NoSplash.splashFactory,
      ),
      home: const ConnectScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/connectscreen':
            return PageTransition(
              child: const ConnectScreen(),
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 200),
              settings: settings,
            );
          case '/controlscreen':
            return PageTransition(
              child: const ControlScreen(),
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 200),
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
