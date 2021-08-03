import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meditop_go/src/components/rounded_button.dart';
import 'package:meditop_go/src/components/rounded_date_field.dart';
import 'package:meditop_go/src/components/rounded_input_field.dart';
import 'package:meditop_go/src/components/rounded_password_field.dart';
import 'package:meditop_go/src/constants.dart';
import 'package:meditop_go/src/services/auth.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

import 'package:fa_stepper/fa_stepper.dart';

import 'background.dart';
import 'dropdown_widget.dart';

enum Genero { masculino, femenino, otro }

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  late bool paciente = true;
  late String names;
  late String lastNames;
  late String email;
  late String password;
  late String passwordConf;
  late String birthday;
  late String ci;
  late String cellphone;
  late String blood;
  String allergies = "";

  TextEditingController birthController = TextEditingController();
  bool registrando = false;
  int _currentStep = 0;
  DropdownWidget dropSex =
      DropdownWidget(items: ['Masculino', 'Femenino', 'Otro']);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Form(
            key: _keyForm,
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.075,
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
                FAStepper(
                  steps: _stepper(),
                  type: FAStepperType.vertical,
                  currentStep: _currentStep,
                  onStepTapped: (step) {
                    setState(() {
                      _currentStep = step;
                    });
                  },
                  onStepContinue: () {
                    setState(() {
                      if (_currentStep < _stepper().length - 1) _currentStep++;
                    });
                  },
                  onStepCancel: () {
                    setState(() {
                      if (_currentStep > 0) _currentStep--;
                    });
                  },
                ),
                RoundedButton(
                    text: 'Registrarse',
                    press: () {
                      registrar(context);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<FAStep> _stepper() {
    /*List<RoundedInputField> listAlergias = [
      RoundedInputField(
        onSaved: (value) => sangre = value!,
        validator: (value) => value!.isEmpty
            ? 'Por favor introduzca una alergia'
            : null,
        icon: Icons.text_fields,
        hintText: "Alergia",
      ),
    ];*/
    return [
      FAStep(
          title: Text('Datos personales'),
          subtitle: Text('Rellena tus datos'),
          content: Column(
            children: [
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
                onSaved: (value) => ci = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Por favor introduzca un CI valido' : null,
                icon: Icons.account_box,
                keyboardType: TextInputType.number,
                hintText: "CI",
              ),
              RoundedInputField(
                onSaved: (value) => cellphone = value!,
                validator: (value) => value!.isEmpty
                    ? 'Por favor introduzca una numero valido'
                    : null,
                icon: Icons.phone,
                hintText: "Numero Celular",
                keyboardType: TextInputType.phone,
              ),
              RoundedDateField(
                controller: birthController,
                onSaved: (value) => birthday = value!,
                validator: (value) => value!.isEmpty
                    ? 'Por favor introduzca una fecha valida'
                    : null,
                hintText: 'Fecha de nacimiento',
              ),
              dropSex,
            ],
          )),
      FAStep(
          title: Text('Datos medicos'),
          subtitle: Text('Rellena tus datos'),
          content: Column(
            children: [
              RoundedInputField(
                onSaved: (value) => blood = value!,
                validator: (value) => value!.isEmpty
                    ? 'Por favor introduzca su tipo de sangre'
                    : null,
                icon: Icons.text_fields,
                hintText: "Tipo de Sangre",
              ),
              RoundedInputField(
                maxLines: 5,
                onSaved: (value) => allergies = value!,
                validator: (value) => null,
                icon: Icons.text_fields,
                hintText:
                    "Alergias, introduzca sus alergias separados por una coma",
              ),
              /*ListView.builder(
                  itemCount: listAlergias.length,
                  itemBuilder: (_, index) => listAlergias[index])*/
            ],
          )),
      FAStep(
          title: Text('Datos de usuario'),
          content: Column(
            children: [
              RoundedInputField(
                onSaved: (value) => email = value!,
                validator: (value) => value!.isEmpty
                    ? 'Por favor introduzca una correo valido'
                    : null,
                icon: Icons.alternate_email,
                keyboardType: TextInputType.emailAddress,
                hintText: "Correo Electronico",
              ),
              RoundedPasswordField(
                onSaved: (value) => password = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Introduzca una contraseña' : null,
              ),
              RoundedPasswordField(
                hintText: "Confirmar contraseña",
                onSaved: (value) => passwordConf = value!,
                validator: (value) => value!.isEmpty
                    ? 'Introduzca la confirmacion de la contraseña'
                    : null,
              ),
            ],
          )),
    ];
  }

  _genero(String gen) {
    switch (gen) {
      case "Masculino":
        return "M";
      case "Femenino":
        return "F";
      default:
        return "O";
    }
  }

  Future registrar(BuildContext context) async {
    ProgressDialog progDialog = new ProgressDialog(context);
    progDialog.style(message: 'Realizando registro, espere por favor...');
    if (!registrando) {
      if (!_keyForm.currentState!.validate()) return;
      _keyForm.currentState!.save();
      await progDialog.show();
      setState(() {
        registrando = true;
      });
      try {
        if (password != passwordConf) {
          await progDialog.hide();
          this.dialog(context, 'Las contraseñas no coinciden');
          setState(() {
            registrando = false;
          });
          return;
        }
        String genero = _genero(dropSex.value);
        String tokenName = await getDeviceName();
        print(genero);
        Map creds = {
          "name": names,
          "last_name": lastNames,
          "ci": ci,
          "cellphone": cellphone,
          "birthday": birthday,
          "sex": genero,
          "type_blood": blood,
          "allergies": allergies + 'Alergias',
          "email": email,
          "password": password,
          "password_confirmation": passwordConf,
          "token_name": tokenName
        };
        Response? response = await Provider.of<Auth>(context, listen: false)
            .register(creds: creds);
        if (response == null)
          throw Exception();
        else if (response.statusCode == 201) {
          await progDialog.hide();
          setState(() {
            registrando = false;
          });
          showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                    title: new Text("Mensaje Registro"),
                    content: new Text(response.data['message']),
                    actions: [
                      // ignore: deprecated_member_use
                      FlatButton(
                        child: Text('Cerrar!'),
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login', (route) => false);
                        },
                      )
                    ],
                  ));
          this.dialog(context, response.data['message']);
        } else if (response.statusCode == 406) {
          await progDialog.hide();
          setState(() {
            registrando = false;
          });
          this.dialog(context, response.data['message']);
          return;
        }
        await progDialog.hide();
        setState(() {
          registrando = false;
        });
      } catch (e) {
        this.dialog(context, "Error en el registro");
        print(e);
        await progDialog.hide();
        setState(() {
          registrando = false;
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

  Future<String> getDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return androidInfo.model;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.utsname.machine;
      }
      return 'Desconocido';
    } catch (e) {
      print(e);
      return 'Desconocido';
    }
  }
}
