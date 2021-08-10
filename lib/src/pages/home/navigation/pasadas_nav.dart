import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditop_go/src/services/auth.dart';
import 'package:meditop_go/src/services/dio.dart';
import 'package:provider/provider.dart';

class PasadasNav extends StatefulWidget {
  @override
  _PasadasNavState createState() => _PasadasNavState();
}

class _PasadasNavState extends State<PasadasNav> {
  List? _pasadas;

  @override
  void initState() {
    super.initState();
    loadPasadas();
  }

  Future<void> loadPasadas() async {
    String? token = Provider.of<Auth>(context, listen: false).token;
    Response response = await http().get('/get-past',
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    setState(() {
      _pasadas = response.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: _pasadas == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Consultas pasadas',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                _pasadas!.length == 0
                    ? Center(child: Text('No tiene consultas pasadas'))
                    : listAgendadas(context),
              ],
            )),
    ));
  }

  Widget listAgendadas(BuildContext context) {
    return ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: this._pasadas!.length,
        itemBuilder: (BuildContext context, int index) {
          String id = _pasadas![index]['id_consult'].toString();
          String doctor = _pasadas![index]['name_doctor'];
          String specialty = _pasadas![index]['name_specialty'];
          String timeConsult = _pasadas![index]['time'].toString();
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
                      subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            Navigator.of(context).pushNamed("/order",
                                arguments: _pasadas[index]['id']);
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
