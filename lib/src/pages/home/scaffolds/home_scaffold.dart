import 'package:flutter/material.dart';
import 'package:meditop_go/src/components/rounded_button.dart';
import 'package:meditop_go/src/services/auth.dart';
import 'package:provider/provider.dart';

import '../background.dart';

class HomeScaffold extends StatefulWidget {
  @override
  _HomeScaffoldState createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, Auth auth, child) {
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
                cerrarSesion(context);
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
              RoundedButton(text: "Entrar", press: () => entrarReunion(context))
            ],
          ),
        )),
      );
    });
  }

  void entrarReunion(BuildContext context) {
    Navigator.of(context).pushNamed("/meet");
  }

  void cerrarSesion(BuildContext context) {
    Provider.of<Auth>(context, listen: false).logout();
  }
}
