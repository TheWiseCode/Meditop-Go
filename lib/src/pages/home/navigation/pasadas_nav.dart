import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PasadasNav extends StatefulWidget {
  @override
  _PasadasNavState createState() => _PasadasNavState();
}

class _PasadasNavState extends State<PasadasNav> {
  List _pasadas = [];

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
                    child: Text('Reservas pasadas',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  _pasadas.length == 0
                      ? Center(child: Text('No tiene reservas pasadas'))
                      : listAgendadas(context),
                ],
              )),
        ));
  }

  Widget listAgendadas(BuildContext context) {
    return ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: this._pasadas.length,
        itemBuilder: (BuildContext context, int index) {
          String id = _pasadas[index]['id'].toString();
          String datetime = _pasadas[index]['datetime'];
          String monto = _pasadas[index]['amount'].toString();
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
                                arguments: _pasadas[index]['id']);
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