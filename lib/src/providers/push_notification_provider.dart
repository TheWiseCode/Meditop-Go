import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushNotificationProvider{

  late GlobalKey<NavigatorState> _navKey;
  late BuildContext contexto;

  PushNotificationProvider(GlobalKey<NavigatorState> navKey){
    _navKey = navKey;
  }

  static FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async{
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
      print("-----TOKEN------");
      print(token);
    });
    FirebaseMessaging.onMessage.listen(onForeground);
    FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpened);
    FirebaseMessaging.onBackgroundMessage(onBackground);
  }

  void onForeground(RemoteMessage message){
    print("-------Mensaje OnForeground----------");
    print("Cuando llega notificacion en 1er plano");
    if(message.notification != null){
      print("Notificacion:");
      print(message.notification!.title);
      print(message.notification!.body);
    }
    print(message.data);
  }

  void onMessageOpened(RemoteMessage message){
    print("Cuando se abre la notificacion en 2do plano");
      print(message.data['comida']);
      String argumento = 'sin-data';
      if(Platform.isAndroid){
        argumento = message.data['comida'] ?? 'sin-data';
      }
      _navKey.currentState!.pushNamed("/notification", arguments: argumento);
  }

  static Future<void> onBackground(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("-------Mensaje OnBackground----------");
    print("Cuando llega notificacion en 2do plano");
    if(message.notification != null){
      print("Notificacion:");
      print(message.notification!.title);
      print(message.notification!.body);
    }
    print(message.data);
  }
}