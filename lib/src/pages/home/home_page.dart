import 'package:flutter/material.dart';
import 'package:meditop_go/src/components/rounded_button.dart';

import 'background.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Inicio")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountEmail: Text("will@gmail.com"),
              accountName: Text("Willy Vargas"),
              currentAccountPicture: FlutterLogo(),
              otherAccountsPictures: [
                FlutterLogo(),
                FlutterLogo(),
                FlutterLogo(),
              ],
              onDetailsPressed: (){},
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blue, Colors.indigo],
                      end: Alignment.bottomRight
                  )
              ),
            ),
            ListTile(
              title: Text("Inicio"),
              leading: Icon(Icons.home),
              onTap: () {},
            ),
          ],
        )
      ),
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
  }

  void entrarReunion(BuildContext context){
    Navigator.of(context).pushNamed("/meet");
  }
}
