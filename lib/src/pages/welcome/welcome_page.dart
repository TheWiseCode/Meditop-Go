import 'package:flutter/material.dart';
import 'package:meditop_go/src/components/rounded_button.dart';
import 'background.dart';
import '../../constants.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}
