import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:meditop_go/src/components/already_have_an_account_acheck.dart';
import 'package:meditop_go/src/components/rounded_button.dart';
import 'package:meditop_go/src/components/rounded_input_field.dart';
import 'package:meditop_go/src/components/rounded_password_field.dart';

import 'background.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

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
                "INGRESAR",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/icons/login.svg",
                height: size.height * 0.35,
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: "Tu Correo",
                onChanged: (value) {},
              ),
              RoundedPasswordField(
                onChanged: (value) {
                },
              ),
              RoundedButton(
                text: "INGRESAR",
                press: () {},
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                press: ()  =>Navigator.pushNamed(context, "/register")
              ),
            ],
          ),
        ),
      ),
    );
  }
}
