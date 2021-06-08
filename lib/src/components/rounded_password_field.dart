import 'package:flutter/material.dart';
import 'package:meditop_go/src/components/text_field_container.dart';

import '../constants.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;

  RoundedPasswordField({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _mostrar = false;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: !_mostrar,
        onChanged: this.widget.onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Contraseña",
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: IconButton(
            icon: Icon(!_mostrar ? Icons.visibility : Icons.visibility_off,
                color: kPrimaryColor),
            onPressed: () {
              setState(() {
                _mostrar = !_mostrar;
              });
            },
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
