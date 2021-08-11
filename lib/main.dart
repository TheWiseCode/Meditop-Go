import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/app.dart';
import 'src/services/auth.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  tz.initializeTimeZones();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (BuildContext context) => Auth.instance(),
    )
  ], child: MyApp()));
}
