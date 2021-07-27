import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:meditop_go/src/components/rounded_button.dart';
import 'package:meditop_go/src/components/rounded_date_field.dart';
import 'package:meditop_go/src/components/rounded_input_field.dart';
import 'package:meditop_go/src/components/rounded_password_field.dart';
import 'package:meditop_go/src/constants.dart';
import 'package:meditop_go/src/services/auth.dart';
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
  Genero gen = Genero.masculino;
  late bool paciente = true;
  late String names;
  late String lastNames;
  late String email;
  late String password;
  late String birthday;
  late String ci;
  late String cellphone;
  late String sangre;

  TextEditingController birthController = TextEditingController();
  bool registrando = false;
  int _currentStep = 0;
  DropdownWidget dropSex = DropdownWidget(items: ['Masculino', 'Femenino', 'Otro']);

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
                SizedBox(height: size.height * 0.075,),
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
                  onStepTapped: (step){
                    setState(() {
                      _currentStep = step;
                    });
                  },
                  onStepContinue: (){
                    setState(() {
                      if(_currentStep < _stepper().length - 1)
                          _currentStep++;
                      else
                        _currentStep = 0;
                    });
                  },
                  onStepCancel: (){
                    setState(() {
                      if(_currentStep > 0)
                          _currentStep--;
                      else
                        _currentStep = _stepper().length - 1;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.black,
          child: Icon(Icons.swap_horizontal_circle)),
    );
  }

  List<FAStep> _stepper() {
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
                onSaved: (value) => sangre = value!,
                validator: (value) =>
                value!.isEmpty ? 'Por favor introduzca su tipo de sangre' : null,
                icon: Icons.text_fields,
                hintText: "Tipo de Sangre",
              ),
            ],
          )),
      FAStep(
          title: Text('Datos de usuario'),
          content: Column(
            children: [],
          )),
    ];
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
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (route) => false);
      } catch (e) {
        dialog(context, "Error en el registro, Email ya registrado");
        print(e);
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
