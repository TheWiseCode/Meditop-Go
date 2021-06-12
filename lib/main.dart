import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/app.dart';
import 'src/services/auth.dart';

void main() async {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (BuildContext context) => Auth(),
    )
  ], child: MyApp()));
}
