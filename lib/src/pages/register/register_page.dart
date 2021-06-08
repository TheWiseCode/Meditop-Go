import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:meditop_go/src/components/rounded_input_field.dart';
import 'package:meditop_go/src/components/rounded_password_field.dart';
import 'package:meditop_go/src/components/text_field_container.dart';

import 'background.dart';

enum Genero { masculino, femenino, otro }

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late bool _registroPaciente = true;
  String _birthday = "";
  Genero gen = Genero.masculino;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.1,
            ),
            Text(
              "REGISTRARSE",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tipo Usuario",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    FlutterSwitch(
                      activeColor: Colors.blue,
                      inactiveColor: Colors.green,
                      activeTextColor: Colors.white,
                      inactiveTextColor: Colors.white,
                      activeText: "Paciente",
                      inactiveText: "Medico",
                      value: _registroPaciente,
                      valueFontSize: 15.0,
                      height: size.height * 0.06,
                      width: size.width * 0.30,
                      borderRadius: 30.0,
                      showOnOff: true,
                      onToggle: (val) {
                        setState(() {
                          _registroPaciente = val;
                        });
                      },
                    ),
                  ]),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RoundedInputField(
                  icon: Icons.text_fields,
                  hintText: "Nombres",
                  onChanged: (value) {},
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RoundedInputField(
                  icon: Icons.text_fields,
                  hintText: "Apellidos",
                  onChanged: (value) {},
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RoundedInputField(
                  icon: Icons.person,
                  hintText: "Correo Electronico",
                  onChanged: (value) {},
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RoundedPasswordField(
                  onChanged: (value) {},
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: TextFieldContainer(
                    child: Text(
                      _birthday,
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Genero"),
                RadioListTile(
                    title: Text("Masculino"),
                    value: Genero.masculino,
                    groupValue: gen,
                    onChanged: (dynamic value) {
                      setState(() {
                        gen = value;
                      });
                    }),
                RadioListTile(
                    title: Text("Femenino"),
                    value: Genero.femenino,
                    groupValue: gen,
                    onChanged: (dynamic value) {
                      setState(() {
                        gen = value;
                      });
                    }),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  Future _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1950),
        lastDate: new DateTime.now());
    if (picked != null) {
      setState(() {
        _birthday = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }
}
