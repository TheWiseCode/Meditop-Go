import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:meditop_go/src/components/rounded_button.dart';
import 'package:meditop_go/src/components/rounded_date_field.dart';
import 'package:meditop_go/src/components/rounded_input_field.dart';
import 'package:meditop_go/src/components/rounded_password_field.dart';
import 'package:meditop_go/src/constants.dart';
import 'package:meditop_go/src/services/auth.dart';
import 'package:provider/provider.dart';

import 'background.dart';

enum Genero { masculino, femenino, otro }

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  Genero gen = Genero.masculino;
  late bool paciente = true;
  late String names;
  late String lastNames;
  late String email;
  late String password;
  late String birthday;
  late String ci;
  late String cellphone;
  TextEditingController birthController = TextEditingController();
  bool registrando = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Background(
      child: SingleChildScrollView(
        child: Form(
          key: _keyForm,
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
              SizedBox(height: size.height * 0.05),
              SizedBox(
                height: size.height * 0.3,
                child: Image.asset(
                  "assets/images/register.png",
                ),
              ),
              SizedBox(height: size.height * 0.05),
              /*Padding(
                padding: EdgeInsets.symmetric(horizontal: size.height * 0.05),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tipo Usuario",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      FlutterSwitch(
                        activeColor: kPrimaryColor,
                        inactiveColor: Colors.green,
                        activeTextColor: Colors.white,
                        inactiveTextColor: Colors.white,
                        activeText: "Paciente",
                        inactiveText: "Medico",
                        value: paciente,
                        valueFontSize: 15.0,
                        height: size.height * 0.06,
                        width: size.width * 0.30,
                        borderRadius: 30.0,
                        showOnOff: true,
                        onToggle: (val) {
                          setState(() {
                            paciente = val;
                          });
                        },
                      ),
                    ]),
              ),*/
              RoundedInputField(
                onSaved: (value) => names = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Por favor introduzca sus nombres' : null,
                icon: Icons.text_fields,
                hintText: "Nombres",
              ),
              RoundedInputField(
                onSaved: (value) => lastNames = value!,
                validator: (value) => value!.isEmpty
                    ? 'Por favor introduzca sus apellidos'
                    : null,
                icon: Icons.text_fields,
                hintText: "Apellidos",
              ),
              RoundedInputField(
                onSaved: (value) => email = value!,
                validator: (value) => value!.isEmpty
                    ? 'Por favor introduzca una correo valido'
                    : null,
                icon: Icons.alternate_email,
                hintText: "Correo Electronico",
              ),
              RoundedPasswordField(
                onSaved: (value) => password = value!,
                validator: (value) => value!.isEmpty
                    ? 'Por favor introduzca una contraseña'
                    : null,
              ),
              RoundedInputField(
                onSaved: (value) => ci = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Por favor introduzca un CI valido' : null,
                icon: Icons.account_box,
                hintText: "CI",
              ),
              RoundedInputField(
                onSaved: (value) => cellphone = value!,
                validator: (value) => value!.isEmpty
                    ? 'Por favor introduzca una numero valido'
                    : null,
                icon: Icons.phone,
                hintText: "Numero Celular",
              ),
              RoundedDateField(
                controller: birthController,
                onSaved: (value) => birthday = value!,
                validator: (value) => value!.isEmpty
                    ? 'Por favor introduzca una fecha valida'
                    : null,
                hintText: 'Fecha de nacimiento',
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.height * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Genero",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: RadioListTile(
                                title: Text("Masculino"),
                                activeColor: kPrimaryColor,
                                contentPadding: EdgeInsets.zero,
                                value: Genero.masculino,
                                groupValue: gen,
                                onChanged: (dynamic value) {
                                  setState(() {
                                    gen = value;
                                  });
                                }),
                          ),
                          Expanded(
                            child: RadioListTile(
                                title: Text("Femenino"),
                                activeColor: kPrimaryColor,
                                contentPadding: EdgeInsets.zero,
                                value: Genero.femenino,
                                groupValue: gen,
                                onChanged: (dynamic value) {
                                  setState(() {
                                    gen = value;
                                  });
                                }),
                          ),
                        ])
                  ],
                ),
              ),
              if (!registrando)
                RoundedButton(
                    text: 'Registrarse',
                    press: () {
                      registrarMongo(context);
                    })
              else
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  width: size.width * 0.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(29),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      color: kPrimaryColor,
                      onPressed: () {},
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ));
  }

  String switchGenero(Genero gen) {
    switch (gen) {
      case Genero.masculino:
        return "M";
      case Genero.femenino:
        return "F";
      case Genero.otro:
        return "O";
    }
  }

  Future<bool> yaRegistrado(String email) async {
    //TODO: Realizar con logica de mongoDB
    return true;
  }

  Future registrarMongo(BuildContext context) async {
    if (!registrando) {
      if (!_keyForm.currentState!.validate()) return;
      _keyForm.currentState!.save();
      setState(() {
        registrando = true;
      });
      try {
        String genero = switchGenero(gen);
        String tokenName = await getDeviceName();
        Map creds = {
          "name": names,
          "last_name": lastNames,
          "ci": ci,
          "cellphone": cellphone,
          "birthday": birthday,
          "sex": genero,
          "email": email,
          "password": password,
          "password_confirmation": password,
          "token_name": tokenName
        };
        bool reg = await Provider.of<Auth>(context, listen: false)
            .register(creds: creds);
        if (!reg) throw Exception();
        Navigator.of(context).popAndPushNamed("/home");
      } catch (e) {
        dialog(context, "Error en el registro");
        print(e);
        setState(() {
          registrando = true;
        });
      }
    }
  }

  void dialog(BuildContext context, String mensaje) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Mensaje Registro"),
              content: new Text(mensaje),
              actions: [
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text('Cerrar!'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ));
  }

  Future<String> getDeviceName() async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try{
      if(Platform.isAndroid){
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.model;
      }else if(Platform.isIOS){
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.utsname.machine;
      }
      return 'Desconocido';
    }catch(e){
      print(e);
      return 'Desconocido';
    }
  }
}
