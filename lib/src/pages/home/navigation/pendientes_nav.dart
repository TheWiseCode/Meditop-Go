import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PendientesNav extends StatefulWidget {
  @override
  _PendientesNavState createState() => _PendientesNavState();
}

class _PendientesNavState extends State<PendientesNav> {
  List _pendientes = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Reservas pendientes',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  _pendientes.length == 0
                      ? Center(child: Text('No tiene reservas pendientes'))
                      : listAgendadas(context),
                ],
              )),
        ));
  }

  Widget listAgendadas(BuildContext context) {
    return ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: this._pendientes.length,
        itemBuilder: (BuildContext context, int index) {
          String id = _pendientes[index]['id'].toString();
          String datetime = _pendientes[index]['datetime'];
          String monto = _pendientes[index]['amount'].toString();
          DateFormat df = DateFormat('yyyy-MM-dd HH:mm:ss');
          DateTime dt = df.parse(datetime);
          String fecha = DateFormat('dd/MM/yyyy').format(dt);
          String time = DateFormat('HH:mm:ss').format(dt);
          return Column(
            children: [
              const SizedBox(height: 5),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.medical_services),
                      title: Text('Numero orden $id'),
                      subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total: $monto Bs'),
                            Text('Fecha: $fecha'),
                            Text('Hora: $time')
                          ]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: const Text('Detalles'),
                          onPressed: () {
                            Navigator.of(context).pushNamed("/order",
                                arguments: _pendientes[index]['id']);
                          },
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
            ],
          );
        });
  }

}