import 'package:flutter/material.dart';
import 'package:meditop_go/src/services/auth.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'drawer_widget.dart';
import 'navigation/agendadas_nav.dart';
import 'navigation/historial_nav.dart';

class HomePage extends StatefulWidget {

int? page;
  HomePage({this.page});

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List _widgetOptions = [
    AgendadasNav(),
    HistorialNav(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      widget.page = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.page == null)
        widget.page = 1;
    return Consumer(builder: (BuildContext context, Auth auth, child) {
      return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text("Meditop Go")),
        drawer: DrawerHome(auth: auth),
        body: Center(
          child: _widgetOptions.elementAt(widget.page as int),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          icon: Icon(Icons.shopping_cart_outlined),
          onPressed: () {
            Navigator.of(context).pushNamed('/reservation1');
          },
          label: Text('Nueva reserva'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Agendadas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Historial',
            ),
          ],
          currentIndex: widget.page as int,
          selectedItemColor: kPrimaryColor,
          onTap: _onItemTapped,
        ),
      );
    });
  }
}
