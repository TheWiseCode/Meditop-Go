import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meditop_go/src/components/rounded_button.dart';
import 'background.dart';
import '../../constants.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
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
              /*SizedBox(
                height: size.height * 0.45,
                child: SvgPicture.asset(
                  "assets/icons/chat.svg",
                  height: size.height * 0.3,
                ),
              ),*/
              SizedBox(
                height: size.height * 0.3,
                child: Image.asset(
                  "assets/images/logo.png",
                ),
              ),
              SizedBox(height: size.height * 0.1),
              RoundedButton(
                  text: "INGRESAR",
                  press: () => Navigator.pushNamed(context, "/login")),
              RoundedButton(
                  text: "REGISTRARSE",
                  color: kPrimaryLightColor,
                  textColor: Colors.black,
                  press: () => Navigator.pushNamed(context, "/register")),
            ],
          ),
        ),
      ),
    );
  }
}
