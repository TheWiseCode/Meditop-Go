import 'dart:io';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meditop_go/src/components/already_have_an_account_acheck.dart';
import 'package:meditop_go/src/components/rounded_button.dart';
import 'package:meditop_go/src/components/rounded_input_field.dart';
import 'package:meditop_go/src/components/rounded_password_field.dart';
import 'package:meditop_go/src/services/auth.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../database/database.dart';

import 'background.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  late String email;
  late String password;
  bool ingresando = false;

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
                Text(
                  "INGRESAR",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.05),
                SizedBox(
                    height: size.height * 0.3,
                    child: Image.asset("assets/images/logo.png")),
                /*SvgPicture.asset(
                  "assets/icons/login.svg",
                  height: size.height * 0.35,
                ),*/
                SizedBox(height: size.height * 0.05),
                RoundedInputField(
                  icon: Icons.alternate_email,
                  onSaved: (value) => email = value!,
                  validator: (value) => value!.isEmpty
                      ? 'Por favor introduzca un correo valido'
                      : null,
                  hintText: "Correo Electronico",
                ),
                RoundedPasswordField(
                  onSaved: (value) => password = value!,
                  validator: (value) => value!.isEmpty
                      ? 'Por favor introduzca una contraseña valida'
                      : null,
                ),
                if (!ingresando)
                  RoundedButton(
                    text: "INGRESAR",
                    press: () {
                      //login(context);
                      loginMongo(context);
                    },
                  )
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
                SizedBox(height: size.height * 0.03),
                AlreadyHaveAnAccountCheck(
                    press: () => Navigator.pushNamed(context, "/register")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future login(BuildContext context) async {
    if (!_keyForm.currentState!.validate()) {
      return;
    }
    _keyForm.currentState!.save();
    try {
      PersonalDatabase db = PersonalDatabase();
      await db.initSimpleDB();
      String query = '''select * from users where email = "$email" limit 1''';
      List<Map<String, Object?>> results = await db.rawQuery(query);
      if (results.isNotEmpty) {
        Map<String, Object?> user = results.elementAt(0);
        String? passHashed = user['password'] as String;
        DBCrypt crypt = DBCrypt();
        bool correcto = crypt.checkpw(password, passHashed);
        print('Contraseña correcta: ' + correcto.toString());
        if (correcto) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/home", (Route<dynamic> route) => false);
          _showToast(context, "Contraseña correcta");
        } else {
          dialog(context, "Contraseña incorrecta");
        }
      } else {
        dialog(context, "Email no encontrado");
      }
      //db.close();
    } catch (e) {
      print(e);
    }
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

  Future loginMongo(BuildContext context) async {
    if (!ingresando) {
      if (!_keyForm.currentState!.validate()) {
        return;
      }
      _keyForm.currentState!.save();
      setState(() {
        ingresando = true;
      });
      String token_name = await getDeviceName();
      Map credenciales = {
        'email': email,
        'password': password,
        'token_name': token_name
        //'device_name' : _deviceName ?? 'desconocido'
      };
      bool logueado = await Provider.of<Auth>(context, listen: false)
          .login(creds: credenciales);
      if (!logueado) {
        dialog(context, "No se pudo inicar sesion");
        setState(() {
          ingresando = false;
        });
        return;
      }
      /*bool puede = await Navigator.of(context).maybePop();
      while(puede){
        Navigator.of(context).pop();
        puede = await Navigator.of(context).maybePop();
      }
      Navigator.of(context).popAndPushNamed("/home");*/
      Navigator.of(context).pop();
    }
  }

  void dialog(BuildContext context, String mensaje) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Mensaje Login"),
              content: new Text(mensaje),
              actions: [
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text('Cerrar!'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  void _showToast(BuildContext context, String msg) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Color.fromRGBO(0, 0, 0, 0.7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check, color: Colors.white),
          SizedBox(
            width: 12.0,
          ),
          Text(msg, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
    FToast ftoast = FToast();
    ftoast.init(context);
    ftoast.showToast(
        child: toast,
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(seconds: 2));
  }
}
