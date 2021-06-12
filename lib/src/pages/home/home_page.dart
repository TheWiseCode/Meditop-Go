import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meditop_go/src/components/rounded_button.dart';
import 'package:meditop_go/src/services/auth.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import 'background.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final storage = FlutterSecureStorage();
  bool tokenLeido = false;

  @override
  void initState() {
    print('---------INIT HOME---------');
    print('VALOR TOKEN LEIDO INIT: ' + tokenLeido.toString());
    init();
    super.initState();
  }

  Future init() async{
    await readToken();
  }

  Future readToken() async {
    //await storage.delete(key: 'token');
    tokenLeido = true;
    String? token = await storage.read(key: 'token');
    Provider.of<Auth>(context, listen: false).tryGetToken(token: token);
    print("---------TOKEN AUTH---------");
    print(token);
    return true;
  }

  Future<bool> _backPressed() async{
    print("BACK PRESSED");
    return true;
  }

  @override
  Widget build(BuildContext context) {
    print("---------BUILD HOME---------");
    /*if (tokenLeido) {
      print("---------TOKEN LEIDO--------");
    } else {

    }*/
    //readToken();
    return WillPopScope(
      onWillPop: _backPressed,
      child: Consumer(builder: (BuildContext context, Auth auth, child) {
        print('VALOR TOKEN LEIDO: ' + tokenLeido.toString());
        if (!tokenLeido) {
          return Scaffold();
        } else
          return auth.authenticated
              ? homeScaffold(context, auth)
              : welcomeScaffold(context);
      }),
    );
  }

  Widget homeScaffold(BuildContext context, Auth auth) {
    return Scaffold(
      appBar: AppBar(title: Text("Inicio")),
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(auth.user!.email),
            accountName: Text(auth.user!.name),
            currentAccountPicture: FlutterLogo(),
            otherAccountsPictures: [
              FlutterLogo(),
              FlutterLogo(),
              FlutterLogo(),
            ],
            onDetailsPressed: () {},
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.blue, Colors.indigo],
                    end: Alignment.bottomRight)),
          ),
          ListTile(
            title: Text("Inicio"),
            leading: Icon(Icons.home),
            onTap: () {},
          ),
          ListTile(
            title: Text("Cerrar sesion"),
            leading: Icon(Icons.logout),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      )),
      body: Background(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Presione en el boton de abajo para ver a que reunion entrar",
              textAlign: TextAlign.center,
            ),
            RoundedButton(
                text: "Entrar",
                press: () {
                  Navigator.of(context).pushNamed("/meet");
                })
          ],
        ),
      )),
    );
  }

  Widget welcomeScaffold(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "BIENVENIDO A MEDITOP GO",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.1),
              SizedBox(
                height: size.height * 0.3,
                child: Image.asset(
                  "assets/images/logo.png",
                ),
              ),
              SizedBox(height: size.height * 0.1),
              RoundedButton(
                  text: "INGRESAR",
                  press: () {
                    //tokenLeido = false;
                    Navigator.pushNamed(context, "/login");
                  }),
              RoundedButton(
                  text: "REGISTRARSE",
                  color: kPrimaryLightColor,
                  textColor: Colors.black,
                  press: () {
                    //tokenLeido = false;
                    Navigator.pushNamed(context, "/register");
                  }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    print("------------DISPOSE------------");
    //tokenLeido = false;
    super.dispose();
  }

  @override
  void deactivate() {
    print("------------DEACTIVE------------");
    //tokenLeido = false;
    super.deactivate();
  }
}
