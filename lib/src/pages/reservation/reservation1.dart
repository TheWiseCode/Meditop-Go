import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meditop_go/src/services/dio.dart';

class Reservation1Page extends StatefulWidget {
  const Reservation1Page({Key? key}) : super(key: key);

  @override
  _Reservation1PageState createState() => _Reservation1PageState();
}

class _Reservation1PageState extends State<Reservation1Page> {
  List? _specialties;

  @override
  void initState() {
    super.initState();
    _loadSpecialties();
  }

  Future<void> _loadSpecialties() async {
    try {
      Response response = await http().get('/specialties');
      setState(() {
        _specialties = response.data;
        print(_specialties);
      });
    } catch (Exception) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Error al cargar las especialidades')),
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
          onPressed: () {
            //Navigator.of(context).pushNamed('/reservation1');
          },
        ),
        body: _specialties == null
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Lista de especialidades',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                    _specialties!.length == 0
                        ? Center(
                            child: Text('No hay especialidades disponibles'))
                        : listSpecialties(context),
                  ],
                )),
              ));
  }

  Widget listSpecialties(BuildContext context) {
    return ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: this._specialties!.length,
        itemBuilder: (BuildContext context, int index) {
          String name = _specialties![index]['name'];
          return Column(
            children: [
              const SizedBox(height: 5),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Icon(Icons.medical_services),
                      title: Text('Especialidad'),
                      subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name),
                          ]),
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
