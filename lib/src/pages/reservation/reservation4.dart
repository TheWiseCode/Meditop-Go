import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditop_go/src/services/dio.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class Reservation4Page extends StatefulWidget {
  Map data;

  Reservation4Page({required this.data}) {
    print(data);
  }

  @override
  _Reservation4PageState createState() => _Reservation4PageState();
}

class _Reservation4PageState extends State<Reservation4Page> {
  String? _cardNumber;
  String? _dateExp;
  int? _cvv;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime datetime = dateFormat.parse(widget.data['datetime']);
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text("Reservacion")),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          icon: Icon(Icons.shopping_cart_outlined),
          onPressed: () => _doReservation(context),
          label: Text('Realizar reserva'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
              child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('Resumen de la reserva',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      SizedBox(height: 10),
                      Text('Doctor: ' + widget.data['name'],
                          style: TextStyle(fontSize: 16)),
                      Text('Especialidad: ' + widget.data['name_specialty'],
                          style: TextStyle(fontSize: 16)),
                      Text(
                          'Fecha de la reserva: ' +
                              DateFormat('dd/MM/yyy').format(datetime),
                          style: TextStyle(fontSize: 16)),
                      Text(
                          'Hora de la reserva: ' +
                              DateFormat('hh:mm:ss').format(datetime),
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 20),
                      /*Text('Datos de pago',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      RoundedInputField(
                        onSaved: (value) => _cardNumber = value!,
                        validator: (value) => value!.isEmpty
                            ? 'Introduzca su numero de tarjeta'
                            : null,
                        icon: Icons.credit_card,
                        hintText: "Numero tarjeta",
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RoundedInputField(
                              width: size.width / 2.5,
                              onSaved: (value) => _dateExp = value!,
                              validator: (value) => value!.isEmpty
                                  ? 'Introduzca una fecha valida'
                                  : null,
                              icon: Icons.date_range,
                              hintText: "Expiracion",
                            ),
                            RoundedInputField(
                              width: size.width / 2.5,
                              onSaved: (value) => _cvv = value! as int?,
                              validator: (value) => value!.isEmpty
                                  ? 'Introduzca un codigo valido'
                                  : null,
                              icon: Icons.pin,
                              hintText: "CVV",
                            ),
                          ],
                        ),
                      ),*/
                      /*RoundedButton(
                          text: 'Verificar disponibilidad',
                          press: () => _verificar(context))*/
                    ],
                  ),
                ),
              ],
            ),
          )),
        ));
  }

  Future<bool> _verificar(BuildContext context) async {
    Map data = {
      'id_offer': widget.data['id_offer'],
      'datetime': widget.data['datetime'],
    };
    try {
      Response response =
          await http().post('/verified-reservation', data: data);
      if (response.statusCode == 200) {
        dialog(context, response.data['message']);
      }
      return true;
    } on DioError catch (e) {
      if (e.response!.statusCode == 406) {
        dialog(context, e.response!.data['message']);
      }
      return false;
    }
  }

  void dialog(BuildContext context, String mensaje) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Mensaje Reserva"),
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

  _doReservation(BuildContext context) async {
    ProgressDialog pd = new ProgressDialog(context: context);
    pd.show(
      max: 100,
      msg: 'Realizando reserva...',
      backgroundColor: Color(0xff212121),
      progressValueColor: Color(0xff3550B4),
      progressBgColor: Colors.white70,
      msgColor: Colors.white,
      valueColor: Colors.white,
    );
    Map data = {
      'id_patient': widget.data['id_patient'],
      'id_offer': widget.data['id_offer'],
      'datetime': widget.data['datetime']
    };
    try {
      Response response = await http().post('/do-reservation', data: data);
      if (response.statusCode == 200) {
        pd.close();
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  title: new Text("Mensaje Reserva"),
                  content: new Text(response.data['message']),
                  actions: [
                    // ignore: deprecated_member_use
                    FlatButton(
                      child: Text('Cerrar!'),
                      onPressed: () => Navigator.of(context)
                          .pushNamedAndRemoveUntil('/home', (route) => false),
                    )
                  ],
                ));
      }
    } on DioError catch (e) {
      pd.close();
      if (e.response!.statusCode == 406) {
        dialog(context, e.response!.data['message']);
      }
    } catch (Exception) {
      pd.close();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Error al realiza la reservacion')),
      );
    }
  }
}
