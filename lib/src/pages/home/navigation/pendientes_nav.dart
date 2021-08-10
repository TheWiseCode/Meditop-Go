import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditop_go/src/services/auth.dart';
import 'package:meditop_go/src/services/dio.dart';
import 'package:provider/provider.dart';

class PendientesNav extends StatefulWidget {
  @override
  _PendientesNavState createState() => _PendientesNavState();
}

class _PendientesNavState extends State<PendientesNav> {
  List? _pendientes;

  @override
  void initState() {
    super.initState();
    loadPendientes();
  }

  Future<void> loadPendientes() async {
    String? token = Provider.of<Auth>(context, listen: false).token;
    Response response = await http().get('/get-pending',
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    setState(() {
      _pendientes = response.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: _pendientes == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Reservas pendientes',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  _pendientes!.length == 0
                      ? Center(child: Text('No tiene reservas pendientes'))
                      : listAgendadas(context),
                ],
              ),
            ),
    ));
  }

  Widget listAgendadas(BuildContext context) {
    return ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: this._pendientes!.length,
        itemBuilder: (BuildContext context, int index) {
          String id = _pendientes![index]['id_reservation'].toString();
          String doctor = _pendientes![index]['name_doctor'];
          String specialty = _pendientes![index]['name_specialty'];
          String timeConsult = _pendientes![index]['time_consult'].toString();
          DateFormat df = DateFormat('yyyy-MM-dd HH:mm:ss');
          DateTime dt = df.parse(timeConsult);
          String fecha = DateFormat('dd/MM/yyyy').format(dt);
          String hora = DateFormat('HH:mm:ss').format(dt);
          return Column(
            children: [
              const SizedBox(height: 5),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.medical_services),
                      title: Text('Especialidad: $specialty'),
                      //Text('Numero orden $id'),
                      subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Text('Especialidad: $specialty'),
                            Text('Doctor: $doctor'),
                            Text('Fecha: $fecha'),
                            Text('Hora: $hora'),
                          ]),
                    ),
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: const Text('Detalles'),
                          onPressed: () {
                            /*Navigator.of(context).pushNamed("/order",
                                arguments: _pendientes[index]['id']);*/
                          },
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),*/
                  ],
                ),
              ),
              const SizedBox(height: 5),
            ],
          );
        });
  }
}
