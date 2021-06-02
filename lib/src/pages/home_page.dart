import 'package:flutter/material.dart';
import 'package:meditop_go/src/models/database.dart';

class HomePage extends StatelessWidget {
  UserDatabase db = UserDatabase();
  HomePage({Key? key}) : super(key: key){
    //db.initDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home page")),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
            // ignore: deprecated_member_use
            child: RaisedButton(
              onPressed: () => _mostrarReunion(context),
              child: Text("Entrar a reunion"),
            )
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 50, vertical:5),
            // ignore: deprecated_member_use
            child: RaisedButton(
              onPressed: () => Navigator.of(context).pushNamed("/login"),
              child: Text("Login"),
            )
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
            // ignore: deprecated_member_use
            child: RaisedButton(
              onPressed: () => Navigator.of(context).pushNamed("/register"),
              child: Text("Register"),
            )
          ),
        ],
      ),
    );
  }

  void _mostrarReunion(BuildContext context){
    Navigator.of(context).pushNamed("/meet");
    /*User user = User(name: "will", password: "will3148");
    db.insert(user);
    print("SUPUESTA INSERCION");*/
  }
}