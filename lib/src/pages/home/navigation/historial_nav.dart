import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditop_go/src/components/dropdown_widget.dart';
import 'package:meditop_go/src/components/text_field_container.dart';
import 'package:meditop_go/src/services/auth.dart';
import 'package:meditop_go/src/services/dio.dart';
import 'package:provider/provider.dart';

class HistorialNav extends StatefulWidget {
  @override
  _HistorialNavState createState() => _HistorialNavState();
}

class _HistorialNavState extends State<HistorialNav> {
  late String value;
  late int selectedItem;
  List? _reservas;
  List? _todas;
  List<String> _filtro = [
    'Todas',
    'Pendiente',
    'Aceptada',
    'Rechazada',
    'Cancelada'
  ];

  @override
  void initState() {
    this.selectedItem = 0;
    this.value = _filtro[0];
    super.initState();
    loadReservasFiltro('todas');
  }

  Future<void> loadReservasFiltro(String filtro) async {
    String? token = Provider.of<Auth>(context, listen: false).token;
    Map data = {'filtro': filtro};
    Response response = await http().post('/get-by-filter',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    print(response.data);
    setState(() {
      _todas = response.data;
      _reservas = _todas;
    });
  }

  Future<void> refresh(String filtro) async {
    String? token = Provider.of<Auth>(context, listen: false).token;
    Map data = {'filtro': filtro};
    Response response = await http().post('/get-by-filter',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    print(response.data);
    setState(() {
      _todas = response.data;
      _reservas = [];
      for (int i = 0; i < _todas!.length; i++) {
        if (_todas![i]['state'] == filtro) {
          _reservas!.add(_todas![i]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: _reservas == null
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => refresh(value.toLowerCase()),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          this.filtroDrop(context),
                          Text('Historial de reservaciones',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    ),
                    _reservas!.length == 0
                        ? Center(child: Text('No tiene ningun reservacion'))
                        : listReservas(context),
                  ],
                ),
              ),
            ),
    ));
  }

  Widget listReservas(BuildContext context) {
    return ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: this._reservas!.length,
        itemBuilder: (BuildContext context, int index) {
          String id = _reservas![index]['id_reservation'].toString();
          String doctor = _reservas![index]['name_doctor'];
          String specialty = _reservas![index]['name_specialty'];
          String timeConsult = _reservas![index]['time_consult'].toString();
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

  void filtrar(String filtro) {
    if(filtro == 'todas'){
      setState(() {
        _reservas = _todas;
      });
      return;
    }
    setState(() {
      _reservas = [];
      for (int i = 0; i < _todas!.length; i++) {
        if (_todas![i]['state'] == filtro) {
          _reservas!.add(_todas![i]);
        }
      }
    });
  }

  Widget filtroDrop(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width * 1;
    return TextFieldContainer(
        width: width,
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          //icon: const Icon(Icons.arrow_downward),
          //iconSize: 24,
          elevation: 16,
          underline: Container(height: 0),
          onChanged: (String? newValue) {
            setState(() {
              selectedItem = posValue(newValue as String);
              value = newValue;
            });
            filtrar(newValue!.toLowerCase());
          },
          items: _filtro.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ));
  }

  int posValue(String newValue) {
    for (int i = 0; i < _filtro.length; i++)
      if (newValue == _filtro[i]) return i;
    return -1;
  }
}
