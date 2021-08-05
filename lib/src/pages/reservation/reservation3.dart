import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditop_go/src/components/rounded_button.dart';
import 'package:meditop_go/src/pages/pays/dropdown_widget.dart';
import 'package:meditop_go/src/services/dio.dart';

class Reservation3Page extends StatefulWidget {
  Map data;

  Reservation3Page({required this.data}) {
    print(data);
  }

  @override
  _Reservation3PageState createState() => _Reservation3PageState();
}

class _Reservation3PageState extends State<Reservation3Page> {
  List? _dates;
  late DropdownWidget dropTimes;

  @override
  void initState() {
    super.initState();
    _dates = [];
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      List<String> times = _loadTimes(widget.data['start'], widget.data['end']);
      dropTimes = DropdownWidget(items: times);
      Map data = {'id_offer': widget.data['id_offer']};
      Response response = await http().post('/offers', data: data);
      setState(() {
        _dates = response.data;
        dropDates = DropdownWidget(items: _cargarDates(_dates));
        print(_dates);
      });
    } catch (Exception) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Error al cargar las fechas')),
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
          onPressed: () => _goToFinalReserve(context),
        ),
        body: _dates == null || dropDates == null
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                    child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text('Seleccionar dia de reserva',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            SizedBox(height: 10),
                            Text('Doctor: ' + widget.data['name'],
                                style: TextStyle(fontSize: 16)),
                            Text(
                                'Especialidad: ' +
                                    widget.data['name_specialty'],
                                style: TextStyle(fontSize: 16)),
                            Text('Horario inicio: ' + widget.data['start'],
                                style: TextStyle(fontSize: 16)),
                            Text('Horario final: ' + widget.data['end'],
                                style: TextStyle(fontSize: 16)),
                            SizedBox(height: 20),
                            Text('Dia de la reserva',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            dropDates!,
                            SizedBox(height: 20),
                            Text('Hora de la reserva',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            dropTimes,
                            SizedBox(height: 20),
                            RoundedButton(
                                text: 'Verificar disponibilidad',
                                press: () => _verificar(context))
                            //listDates(context)
                            /*DateField(
                              width: double.infinity,
                              onSaved: (value) => date = value!,
                              validator: (value) => value!.isEmpty
                                  ? 'Introduzca la fecha de la reserva'
                                  : null,
                              hintText: 'Ejm: 2020-08-07',
                              controller: _dateText,
                            ),*/
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ));
  }

  List<String> _cargarDates(List? dates) {
    List<String> fechas = [];
    for (int i = 0; i < dates!.length; i++) {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      DateTime dateTime = dateFormat.parse(dates[i]);
      String date = _dayName(dateTime.weekday) +
          ' ' +
          dateTime.day.toString() +
          ' de ' +
          _monthName(dateTime.month) +
          ' de ' +
          dateTime.year.toString();
      fechas.add(date);
    }
    return fechas;
  }

  String _dayName(int day) {
    List names = [
      'Lunes',
      'Martes',
      'Miercoles',
      'Jueves',
      'Viernes',
      'Sabado',
      'Domingo'
    ];
    return names[day - 1];
  }

  String _monthName(int month) {
    List names = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Novimbre',
      'Diciembre'
    ];
    return names[month - 1];
  }

  DropdownWidget? dropDates;

  _goToFinalReserve(BuildContext context) async {
    bool verificado = await _verificar(context);
    if(!verificado){
      return;
    }
    Map data = {};
    Navigator.of(context).pushNamed('/reservation4', arguments: data);
  }

  List<String> _loadTimes(start, end) {
    DateFormat dateFormat = DateFormat("HH:mm:ss");
    DateTime timeStart = dateFormat.parse(start.toString());
    DateTime timeEnd = dateFormat.parse(end.toString());
    TimeOfDay tstart = TimeOfDay.fromDateTime(timeStart);
    TimeOfDay tend = TimeOfDay.fromDateTime(timeEnd);
    List<String> times = [];
    while (!(tstart.hour == tend.hour && tstart.minute == tend.minute)) {
      times.add(tstart.hour.toString().padLeft(2, '0') +
          ':' +
          tstart.minute.toString().padLeft(2, '0'));
      tstart = addMinutes(tstart, 30);
    }
    return times;
  }

  TimeOfDay addMinutes(TimeOfDay time, int minutes) {
    if (minutes == 0) {
      return time;
    } else {
      int mofd = time.hour * 60 + time.minute;
      int newMofd = ((minutes % 1440) + mofd + 1440) % 1440;
      if (mofd == newMofd) {
        return time;
      } else {
        int newHour = newMofd ~/ 60;
        int newMinute = newMofd % 60;
        return TimeOfDay(hour: newHour, minute: newMinute);
      }
    }
  }

  Future<bool> _verificar(BuildContext context) async {
    Map data = {
      'id_offer': widget.data['id_offer'],
      'date': _dates![dropDates!.selectedItem as int],
      'time': dropTimes.value
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
}
