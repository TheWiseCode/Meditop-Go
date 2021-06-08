import 'package:flutter/material.dart';
import 'package:meditop_go/src/constants.dart';
import 'models/database.dart';
import 'pages/home/home_page.dart';
import 'pages/login/login_page.dart';
import 'pages/meet/meet_page.dart';
import 'pages/notification/notification_page.dart';
import 'pages/register/register_page.dart';
import 'providers/push_notification_provider.dart';

class MyApp extends StatefulWidget {

  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  UserDatabase db = UserDatabase();
  GlobalKey<NavigatorState> navKey = new GlobalKey<NavigatorState>();
  late PushNotificationProvider provider;

  Future<void> init() async {
    provider = PushNotificationProvider(navKey);
    await provider.initNotifications();
    //await PushNotificationProvider.initNotifications();
    provider.mensajes.listen((args) {
      navKey.currentState!.pushNamed("/notification", arguments: args);
    });
  }

  @override
  void initState() {
    super.initState();
    init();
    //db.initDB();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        accentColor: Colors.indigo[600],
        appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white))
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: navKey,
      title: 'Meditop Go',
      initialRoute: "/",
      onGenerateRoute: (RouteSettings settings) {
        // ignore: missing_return
        return MaterialPageRoute(
          builder: (BuildContext context) {
            switch (settings.name) {
              case "/":
                return HomePage();
              case "/login":
                return LoginPage();
              case "/register":
                return RegisterPage();
              case "/meet":
                return Meeting();
              case "/notification":
                String? texto = settings.arguments as String?;
                return NotificationPage(texto: texto);
              default:
                return HomePage();
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
