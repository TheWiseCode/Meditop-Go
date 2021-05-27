import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home page")),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            // ignore: deprecated_member_use
            child: RaisedButton(
              onPressed: () => _mostrarReunion(context),
              child: Text("Entrar a reunion"),
            )
          )
        ],
      ),
    );
  }

  void _mostrarReunion(BuildContext context){
    Navigator.of(context).pushNamed("/meet");
  }
}