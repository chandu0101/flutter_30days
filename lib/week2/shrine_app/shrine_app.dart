import 'package:flutter/material.dart';
import 'package:flutter_30days/week2/shrine_app/home.dart';
import 'package:flutter_30days/week2/shrine_app/login.dart';
import 'package:flutter_30days/week2/shrine_app/theme.dart';

class ShrineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Shrine App",
      initialRoute: "/login",
      theme: kShrineTheme,
      debugShowCheckedModeBanner: false,
      home: ShrineHomeScreen(),
      onGenerateRoute: _onGenerateRoute,
    );
  }
}

MaterialPageRoute? _onGenerateRoute(RouteSettings settings) {
  if (settings.name != "/login") {
    return null;
  }

  return MaterialPageRoute(builder: (context) => ShrineLoginScreen());
}
