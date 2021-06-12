import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:meditop_go/src/components/rounded_button.dart';
import 'package:meditop_go/src/components/rounded_date_field.dart';
import 'package:meditop_go/src/components/rounded_input_field.dart';
import 'package:meditop_go/src/components/rounded_password_field.dart';
import 'package:meditop_go/src/constants.dart';
import 'package:meditop_go/src/services/auth.dart';
import 'package:provider/provider.dart';
import '../../database/database.dart';

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
              Padding(
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
              ),
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
                icon: Icons.person,
                hintText: "Correo Electronico",
              ),
              RoundedPasswordField(
                onSaved: (value) => password = value!,
                validator: (value) => value!.isEmpty
                    ? 'Por favor introduzca una contraseña'
                    : null,
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

  Future registrar(BuildContext context) async {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
    }
    bool registrado = await yaRegistrado(email);
    if (registrado) {
      dialog(context, "Error: Cliente ya registrado");
      return;
    }
    DBCrypt crypt = DBCrypt();
    String salt = crypt.gensaltWithRounds(10);
    String passEncrypted = crypt.hashpw(password, salt);
    try {
      PersonalDatabase db = PersonalDatabase();
      await db.initSimpleDB();
      String genero = switchGenero(gen);
      Map<String, Object?> map = {
        "names": names,
        "lastNames": lastNames,
        "email": email,
        "password": passEncrypted,
        "birthday": birthday,
        "gender": genero,
      };
      User user = User.fromMap(map);
      await db.insert(user);
      /*String query =
          '''insert into users(names, lastNames, email, password, birthday, gender)
          values ("$names", "$lastNames", "$email", "$passEncrypted", "$birthday", "$genero")''';
      await db.execute(query);*/
      //db.close();
      Navigator.of(context).pushReplacementNamed("/home");
    } catch (e) {
      print(e);
    }
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
    PersonalDatabase db = PersonalDatabase();
    await db.initSimpleDB();
    String query = '''select * from users where email = "$email" limit 1''';
    List<Map<String, Object?>> results = await db.rawQuery(query);
    //db.close();
    return results.isNotEmpty;
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
        Map creds = {
          "name": names,
          "last_name": lastNames,
          "ci": "11341907 SC",
          "cellphone": "75337753",
          "birthday": birthday,
          "sex": genero,
          "email": email,
          "password": password,
          "password_confirmation": password,
        };
        bool reg = await Provider.of<Auth>(context, listen: false)
            .register(creds: creds);
        if (!reg) throw Exception();
        Navigator.of(context).pop();
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
}
