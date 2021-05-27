import 'package:flutter/material.dart';
import 'package:meditop_go/src/pages/notification_page.dart';
import 'pages/meet_page.dart';
import 'pages/home_page.dart';
import 'providers/push_notification_provider.dart';

// ignore: must_be_immutable
class MyApp extends StatelessWidget {

  GlobalKey<NavigatorState> navKey = new GlobalKey<NavigatorState>();
  late PushNotificationProvider provider;

  MyApp({Key? key}) : super(key: key){
    provider = PushNotificationProvider(navKey);
    init();
  }

  Future<void> init() async {
    //await PushNotificationProvider.initNotifications();
    await provider.initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color.fromRGBO(0x1c, 0x4e, 0x91, 1),
        accentColor: Colors.indigo[600],
        appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white))
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: navKey,
      title: 'Meditop Go',
      initialRoute: "/",
      onGenerateRoute: (RouteSettings settings) {
        print(settings.arguments);
        // ignore: missing_return
        return MaterialPageRoute(
          builder: (BuildContext context) {
            switch (settings.name) {
              case "/":
                return MyHomePage();
              case "/meet":
                return Meeting();
              case "/notification":
                String? texto = settings.arguments as String?;
                return NotificationPage(texto: texto);
              default:
                return MyHomePage();
          }
        });
      /*routes: {
        "/": (BuildContext context) => MyHomePage(),
        "/meet": (BuildContext context) => Meeting(),
        "/notification": (BuildContext context) => NotificationPage(),
       */},
    );
  }
}