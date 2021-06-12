import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationProvider {
  static late GlobalKey<NavigatorState> _navKey;
  static FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static late String args;

  // ignore: close_sinks
  final _mensajesStreamController = StreamController<String>.broadcast();
  Stream<String> get mensajes => _mensajesStreamController.stream;

  PushNotificationProvider(GlobalKey<NavigatorState> navKey) {
    _navKey = navKey;
  }

  Future<void> initNotifications() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    _messaging.getToken().then((token) {
      print("-----TOKEN FIREBASE------");
      print(token);
    });
    FirebaseMessaging.onMessage.listen(onForeground);
    FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpened);
    FirebaseMessaging.onBackgroundMessage(onBackground);
  }

  void onForeground(RemoteMessage message) {
    print("-------Mensaje OnForeground----------");
    print("Cuando llega notificacion en 1er plano");
    if (message.notification != null) {
      args = 'sin-data';
      if (Platform.isAndroid) {
        args = message.data['comida'] ?? 'sin-data';
      }
      //_mensajesStreamController.sink.add(args);
      _navKey.currentState!.restorablePush(_dialogBuilder);
      print("Notificacion:");
      print(message.notification!.title);
      print(message.notification!.body);
    }
    print(message.data);
  }

  void onMessageOpened(RemoteMessage message) {
    print("Cuando se abre la notificacion en 2do plano");
    print(message.data['comida']);
    args = 'sin-data';
    if (Platform.isAndroid) {
      args = message.data['comida'] ?? 'sin-data';
    }
    _mensajesStreamController.sink.add(args);
    //_navKey.currentState!.pushNamed("/notification", arguments: args);
  }

  static Future<void> onBackground(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("-------Mensaje OnBackground----------");
    print("Cuando llega notificacion en 2do plano");
    if (message.notification != null) {
      print("Notificacion:");
      print(message.notification!.title);
      print(message.notification!.body);
    }
    print(message.data);
  }

  static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    return DialogRoute<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Tienes una nueva notificacion!'),
            children: [
              SimpleDialogOption(
                  onPressed: () {
                    _navKey.currentState!.pop();
                  },
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    onPressed: (){
                      _navKey.currentState!.pop();
                      _navKey.currentState!.pushNamed("/notification", arguments: args);
                    },
                    child: Text('Ver'),
                  )),
            ],
          );
        });
  }

  void dispose(){
    _mensajesStreamController.close();
  }
}
