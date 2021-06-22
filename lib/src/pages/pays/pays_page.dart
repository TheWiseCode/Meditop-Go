import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meditop_go/src/components/background.dart';
import 'package:meditop_go/src/components/rounded_button.dart';
import 'package:meditop_go/src/components/rounded_input_field.dart';
import 'package:meditop_go/src/pages/pays/dropdown_widget.dart';
import 'package:meditop_go/src/services/auth.dart';
import 'package:meditop_go/src/services/dio.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class PayPage extends StatefulWidget {
  const PayPage({Key? key}) : super(key: key);

  @override
  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  late String amount;
  late String coin;
  List? dataAccounts;
  List<String> number = [];
  DropdownWidget dropTransaction = DropdownWidget(items: ['Abonar', 'Retirar']);
  DropdownWidget? dropNumbers;

  @override
  void initState() {
    super.initState();
    getCuentas();
  }

  Future getCuentas() async {
    String? token = await Provider.of<Auth>(context, listen: false).token;
    Response response = await http().get('/accounts',
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    dataAccounts = response.data['data'];
    dataAccounts!.forEach((element) {
      number.add(element['number']);
    });
    dropNumbers = DropdownWidget(items: this.number);
    setState(() {});
  }

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
                'REALIZA TRANSACCION',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              dropTransaction,
              RoundedInputField(
                keyboardType: TextInputType.number,
                onSaved: (value) => amount = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Introduzca un monto' : null,
                icon: Icons.money,
                hintText: 'Monto (Bs)',
              ),
              RoundedInputField(
                controller: TextEditingController(text: 'BS'),
                onSaved: (value) => coin = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Seleccione una divisa' : null,
                icon: Icons.monetization_on_outlined,
                hintText: 'Divisa',
              ),
              if (dropNumbers != null) dropNumbers as DropdownWidget,
              RoundedButton(
                  text: 'Realizar transacción',
                  press: () => _doTransaction(context))
            ],
          ),
        ),
      ),
    ));
  }

  _doTransaction(BuildContext context) async {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      ProgressDialog dialog = new ProgressDialog(context);
      dialog.style(message: 'Espere por favor...');
      await dialog.show();
      String? idAccount = _getIdAccount(this.dropNumbers!.value);
      print(idAccount);
      Map data = {
        'type': dropTransaction.value,
        'amount': double.parse(amount),
        'coin_type': this.coin,
        'id_account': idAccount
      };
      String? token = await Provider.of<Auth>(context, listen: false).token;
      try {
        Response? response;
        if (dropTransaction.value == 'Abonar') {
          response = await http().post('/transaction/deposit',
              data: data,
              options: Options(headers: {'Authorization': 'Bearer $token'}));
          print(response.data.toString());
        } else if (dropTransaction.value == 'Retirar') {
          response = await http().post('/transaction/extract',
              data: data,
              options: Options(headers: {'Authorization': 'Bearer $token'}));
        }
        if (response != null) {
          await dialog.hide();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(
                duration: Duration(milliseconds: 1200),
                content: Text(response.data['message']),
              )).closed.then((value) => _keyForm.currentState!.reset());
        }
      } on DioError catch (e) {
        await dialog.hide();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(
              duration: Duration(milliseconds: 1200),
              content: Text(e.response!.data['message']),
            ));
      }
    }
  }

  String? _getIdAccount(String? number) {
    if (number == null) return null;
    for (int i = 0; i < dataAccounts!.length; i++) {
      if (dataAccounts![i]['number'] == number) return dataAccounts![i]['_id'];
    }
    return null;
  }
}
