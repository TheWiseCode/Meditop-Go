import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'pages/home/home_page.dart';
import 'pages/load/load_page.dart';
import 'pages/login/login_page.dart';
import 'pages/meet/meet_page.dart';
import 'pages/notification/notification_page.dart';
import 'pages/register/register_page.dart';
import 'pages/reservation/reservation1.dart';
import 'pages/reservation/reservation2.dart';
import 'pages/reservation/reservation3.dart';
import 'pages/reservation/reservation4.dart';
import 'pages/welcome/welcome_page.dart';
import 'providers/push_notification_provider.dart';
import 'services/auth.dart';

class MyApp extends StatefulWidget {
  static late PushNotificationProvider provider;
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  //PersonalDatabase db = PersonalDatabase();
  GlobalKey<NavigatorState> navKey = new GlobalKey<NavigatorState>();
  //static late PushNotificationProvider provider;
  final storage = FlutterSecureStorage();

  Future<void> init() async {
    MyApp.provider = PushNotificationProvider(navKey);
    await MyApp.provider.initNotificationsToken();
    MyApp.provider.mensajes.listen((args) {
      navKey.currentState!.pushNamed("/notification", arguments: args);
    });
  }

  @override
  void initState() {
    super.initState();
    readToken();
    init();
  }

  Future readToken() async {
    //await storage.delete(key: 'token');
    String? token = await storage.read(key: 'token');
    print('TOKEN APP INIT');
    print(token);
    Provider.of<Auth>(context, listen: false).tryGetToken(token: token);
    print('READED TOKEN APP INIT');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          accentColor: Colors.indigo[600],
          appBarTheme:
              AppBarTheme(iconTheme: IconThemeData(color: Colors.white))),
      debugShowCheckedModeBanner: false,
      navigatorKey: navKey,
      title: 'Meditop Go',
      home: Consumer(
        builder: (context, Auth auth, child) {
          switch (auth.status) {
            case AuthStatus.Uninitialized:
              return LoadPage();
            case AuthStatus.Authenticated:
              return HomePage();
            case AuthStatus.Unauthenticated:
              return WelcomePage();
          }
        },
      ),
      onGenerateRoute: (RouteSettings settings) {
        // ignore: missing_return
        return MaterialPageRoute(builder: (BuildContext context) {
          switch (settings.name) {
            case "/welcome":
              return WelcomePage();
            case "/login":
              return LoginPage();
            case "/register":
              return RegisterPage();
            case "/meet":
              return MeetPage();
            case "/home":
              return HomePage();
            case "/reservation1":
              return Reservation1Page();
            case "/reservation2":
              Map data = settings.arguments as Map;
              return Reservation2Page(data: data);
            case "/reservation3":
              Map data = settings.arguments as Map;
              return Reservation3Page(data: data);
            case "/reservation4":
              Map data = settings.arguments as Map;
              return Reservation4Page(data: data);
            case "/notification":
              String? texto = settings.arguments as String?;
              return NotificationPage(texto: texto);
            default:
              return HomePage();
          }
        });
      },
    );
  }
}
