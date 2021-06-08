import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditop_go/src/components/text_field_container.dart';

import '../constants.dart';

class RoundedDateField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller = TextEditingController();
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;

  RoundedDateField(
      {Key? key,
      required this.hintText,
      this.icon = Icons.calendar_today,
      this.onSaved,
      this.validator})
      : super(key: key);

  @override
  _RoundedDateFieldState createState() => _RoundedDateFieldState();
}

class _RoundedDateFieldState extends State<RoundedDateField> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: TextFormField(
            onTap: () => _selectDate(context),
            readOnly: true,
            validator: widget.validator,
            onSaved: widget.onSaved,
            enabled: true,
            controller: widget.controller,
            cursorColor: kPrimaryColor,
            decoration: InputDecoration(
              icon: Icon(
                widget.icon,
                color: kPrimaryColor,
              ),
              hintText: widget.hintText,
              border: InputBorder.none,
            )));
  }

  Future _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1950),
        lastDate: new DateTime.now());
    if (picked != null) {
      setState(() {
        widget.controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
}
