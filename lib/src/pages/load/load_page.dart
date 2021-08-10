import 'package:flutter/material.dart';
import 'package:meditop_go/src/services/auth.dart';
import 'package:provider/provider.dart';

class LoadPage extends StatefulWidget {
  @override
  _LoadPageState createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, Auth auth, child) {
      return Scaffold(body: body(context));
    });
  }

  Widget body(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'BIENVENIDO A MEDITOP GO',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            height: size.height * 0.3,
            child: Image.asset(
              "assets/images/logo.png",
            ),
          ),
          SizedBox(
            height: 15,
          ),
          CircularProgressIndicator()
        ],
      ),
    );
  }
}
