import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meditop_go/src/services/dio.dart';

class Reservation2Page extends StatefulWidget {
  Map data;

  Reservation2Page({required this.data}) {
    print(data);
  }

  @override
  _Reservation2PageState createState() => _Reservation2PageState();
}

class _Reservation2PageState extends State<Reservation2Page> {
  List? _schedules;

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    try {
      Map data = {'id_specialty': widget.data['id_specialty']};
      Response response = await http().post('/schedules', data: data);
      setState(() {
        _schedules = response.data;
        print(_schedules);
      });
    } catch (Exception) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Error al cargar los horarios')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text("Reservacion")),
        //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.arrow_forward_rounded),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          onPressed: () => _goToSelectDate(context),
        ),
        body: _schedules == null
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Doctores disponibles',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    _schedules!.length == 0
                        ? Center(child: Text('No hay horarios disponigles'))
                        : listSchedule(context),
                  ],
                )),
              ));
  }

  int _selected = -1;

  Widget listSchedule(BuildContext context) {
    return ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: this._schedules!.length,
        itemBuilder: (BuildContext context, int index) {
          String name = _schedules![index]['name'] +
              ' ' +
              _schedules![index]['last_name'];
          String start = _schedules![index]['time_start'].toString();
          String end = _schedules![index]['time_end'].toString();
          String days = _daysLine(_schedules![index]['days']);
          return GestureDetector(
            onTap: () {
              setState(() {
                _selected = index;
              });
            },
            child: Column(
              children: [
                const SizedBox(height: 5),
                Card(
                  color: index == _selected
                      ? Color.fromRGBO(202, 234, 255, 1)
                      : Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Dr.' + name),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Dias de atencion: ' + days),
                              Text('Horario inicio: ' + start),
                              Text('Horario final: ' + end),
                            ]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          );
        });
  }

  String _daysLine(List _days) {
    String s = '';
    for (int i = 0; i < _days.length; i++) {
      switch (_days[i]) {
        case 'Lunes':
          s += 'Lun,';
          break;
        case 'Martes':
          s += 'Mar';
          break;
        case 'Miercoles':
          s += 'Mier,';
          break;
        case 'Jueves':
          s += 'Jue';
          break;
        case 'Viernes':
          s += 'Vier';
          break;
        case 'Sabado':
          s += 'Sab';
          break;
        case 'Domingo':
          s += 'Dom';
          break;
      }
    }
    return s;
  }

  _goToSelectDate(BuildContext context) {
    if (_selected == -1) {
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
                title: new Text("Mensaje Reserva"),
                content: new Text("Seleccione un doctor para continuar"),
                actions: [
                  // ignore: deprecated_member_use
                  FlatButton(
                    child: Text('Cerrar!'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ));
      return;
    }
    Map data = {
      'id_specialty': widget.data['id_specialty'],
      'name_specialty': widget.data['name_specialty'],
      'id_offer': _schedules![_selected]['id_offer'],
      'name': _schedules![_selected]['name'] +
          ' ' +
          _schedules![_selected]['last_name'],
      'start': _schedules![_selected]['time_start'],
      'end': _schedules![_selected]['time_end'],
    };
    Navigator.of(context).pushNamed('/reservation3', arguments: data);
  }
}
