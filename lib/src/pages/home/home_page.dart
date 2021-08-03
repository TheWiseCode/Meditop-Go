import 'package:flutter/material.dart';
import 'package:meditop_go/src/services/auth.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'drawer_widget.dart';
import 'navigation/agendadas_nav.dart';
import 'navigation/pasadas_nav.dart';
import 'navigation/pendientes_nav.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  List _widgetOptions = [
    PasadasNav(),
    AgendadasNav(),
    PendientesNav(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, Auth auth, child) {
      return Scaffold(
        appBar: AppBar(centerTitle: true, title: Text("Meditop Go")),
        drawer: DrawerHome(auth: auth),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
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
              icon: Icon(Icons.home),
              label: 'Pasadas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Agendadas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Pendientes',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: kPrimaryColor,
          onTap: _onItemTapped,
        ),
      );
    });
  }
}
