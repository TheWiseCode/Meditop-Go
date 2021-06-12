import 'package:flutter/material.dart';
import 'package:meditop_go/src/components/rounded_button.dart';
import 'package:meditop_go/src/services/auth.dart';
import 'package:provider/provider.dart';
import 'background.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, Auth auth, child) {
      return Scaffold(
        appBar: AppBar(title: Text("Inicio")),
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: [
            if (auth.user != null)
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
                onTap: () => _cerrarSesion(context)),
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
    });
  }

  void _cerrarSesion(BuildContext context) {
    Provider.of<Auth>(context, listen: false).logout();
    Navigator.of(context).popAndPushNamed("/welcome");
  }
}
