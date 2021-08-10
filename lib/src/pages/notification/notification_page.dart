import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NotificationPage extends StatelessWidget {
  late String text;

  NotificationPage({Key? key, String? texto}) : super(key: key) {
    if (texto == null)
      text = "null";
    else
      text = texto;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Notificaciones',
        textAlign: TextAlign.center,
      )),
      body: Center(child: Text(text)),
    );
  }
}
