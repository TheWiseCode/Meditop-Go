import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meditop_go/src/components/rounded_button.dart';
import 'package:meditop_go/src/components/dropdown_widget.dart';
import 'package:meditop_go/src/services/auth.dart';
import 'package:meditop_go/src/services/dio.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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
  List? _times;
  CalendarController calController = CalendarController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      _times = [];
      _loadTimes(widget.data['start'], widget.data['end']);
      Map data = {'id_offer': widget.data['id_offer']};
      Response response = await http().post('/offers', data: data);
      setState(() {
        _dates = response.data;
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
    DateTime? dateInitial;
    DateTime? dateEnd;
    double? timeStart;
    double? timeEnd;
    if (_dates != null && _times != null) {
      int n = _dates!.length;
      int m = _times!.length;
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
      DateFormat timeFormat = DateFormat("HH:mm");
      DateTime timeI = timeFormat.parse(_times![0]);
      DateTime timeE =
          timeFormat.parse(_times![m - 1]).add(Duration(minutes: 30));
      dateInitial = dateFormat.parse(_dates![0] + ' 00:00');
      dateEnd = dateFormat.parse(_dates![n - 1] + ' 00:00').add(Duration(days: 1));
      timeStart = timeI.hour + timeI.minute / 60;
      timeEnd = timeE.hour + timeE.minute / 60;
    }
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text("Reservacion")),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.arrow_forward_rounded),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          onPressed: () => _goToFinalReserve(context),
        ),
        body: _dates == null
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
                            Text('Doctor: ' + widget.data['name'],
                                style: TextStyle(fontSize: 16)),
                            Text(
                                'Especialidad: ' +
                                    widget.data['name_specialty'],
                                style: TextStyle(fontSize: 16)),
                            Text('Horario: ' + widget.data['start']+' - '+widget.data['end'],
                                style: TextStyle(fontSize: 16)),
                            Text('Dias atencion: ' + widget.data['schedule'],
                                style: TextStyle(fontSize: 16)),
                            Container(
                              height: 500,
                              child: SfCalendar(
                                controller: calController,
                                blackoutDates: [
                                  DateTime.now().add(Duration(days: 2))
                                ],
                                view: CalendarView.week,
                                timeSlotViewSettings: TimeSlotViewSettings(
                                    //nonWorkingDays: [6, 7],
                                    startHour: timeStart as double,
                                    endHour: timeEnd as double,
                                    timeFormat: 'HH:mm',
                                    timeInterval: const Duration(minutes: 30)),
                                //initialDisplayDate: dateTime,
                                firstDayOfWeek: dateInitial!.weekday,
                                minDate: dateInitial,
                                maxDate: dateEnd,
                                //initialDisplayDate: DateTime(2021, 08, 11, 06, 00),
                                //initialSelectedDate: DateTime(2021, 08, 11, 06, 00),
                              ),
                            ),
                            RoundedButton(
                                text: 'Verificar disponibilidad',
                                press: () => _verificar(context, true)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ));
  }

  _goToFinalReserve(BuildContext context) async {
    bool verificado = await _verificar(context, false);
    if (!verificado) {
      return;
    }
    int id = Provider.of<Auth>(context, listen: false).user!.idPatient;
    String datetime = DateFormat('yyyy-MM-dd HH:mm:ss')
        .format(calController.selectedDate as DateTime);
    Map data = {
      'id_patient': id,
      'id_offer': widget.data['id_offer'],
      'datetime': datetime,
      'name_specialty': widget.data['name_specialty'],
      'name': widget.data['name'],
    };
    Navigator.of(context).pushNamed('/reservation4', arguments: data);
  }

  void _loadTimes(start, end) {
    DateFormat dateFormat = DateFormat("HH:mm:ss");
    DateTime timeStart = dateFormat.parse(start.toString());
    DateTime timeEnd = dateFormat.parse(end.toString());
    TimeOfDay tstart = TimeOfDay.fromDateTime(timeStart);
    TimeOfDay tend = TimeOfDay.fromDateTime(timeEnd);
    while (!(tstart.hour == tend.hour && tstart.minute == tend.minute)) {
      String time = tstart.hour.toString().padLeft(2, '0') +
          ':' +
          tstart.minute.toString().padLeft(2, '0');
      _times!.add(time);
      tstart = addMinutes(tstart, 30);
    }
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

  bool _verificarHorarioDia(DateTime day1){
    DateTime compare = DateTime(day1.year, day1.month, day1.day);
    for (int i = 0; i < _dates!.length; i++) {
      DateFormat df = DateFormat('yyyy-MM-dd');
      DateTime day = df.parse(_dates![i]);
      if(day.compareTo(compare) == 0)
        return true;
    }
    return false;
  }

  Future<bool> _verificar(BuildContext context, bool mostrarTrue) async {
    if (calController.selectedDate == null) {
      dialog(context, 'Seleccione un horario para continuar');
      return false;
    }
    DateTime selected = calController.selectedDate as DateTime;
    if(!_verificarHorarioDia(selected)){
        dialog(context, 'Seleccione un dia valido de horario para continuar');
        return false;
    }
    String datetime = DateFormat('yyyy-MM-dd HH:mm:ss').format(selected);
    Map data = {
      'id_offer': widget.data['id_offer'],
      'datetime': datetime,
    };
    try {
      Response response =
          await http().post('/verified-reservation', data: data);
      if (response.statusCode == 200 && mostrarTrue) {
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
