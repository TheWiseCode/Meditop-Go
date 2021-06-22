import 'package:flutter/material.dart';
import 'package:meditop_go/src/services/auth.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DrawerHome extends StatefulWidget {
  Auth auth;

  DrawerHome({required this.auth});

  @override
  _DrawerHomeState createState() => _DrawerHomeState();
}

class _DrawerHomeState extends State<DrawerHome> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            if (widget.auth.user != null)
              UserAccountsDrawerHeader(
                arrowColor: Colors.transparent,
                //onDetailsPressed: () {},
                accountEmail: Text(widget.auth.user!.email),
                accountName: Text(widget.auth.user!.name),
                currentAccountPicture: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    'https://image.freepik.com/vector-gratis/perfil-avatar-hombre-icono-redondo_24640-14044.jpg'
                    //widget.auth.user!.profilePhotoUrl,
                  ),
                ),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.orange.shade600, Colors.red.shade400],
                        end: Alignment.bottomRight)),
              ),
            ListTile(
              title: Text("Inicio"),
              leading: Icon(Icons.home),
              onTap: () => Navigator.of(context).pop(),
            ),
            Divider(height: 15),
            ListTile(
              title: Text("Mi cuenta"),
              leading: Icon(Icons.person),
              onTap: () {},
            ),
            ListTile(
              title: Text("Pagos"),
              leading: Icon(Icons.credit_card),
              onTap: () {
                _verPagosPage(context);
              },
            ),
            ListTile(
              title: Text("Configuracion"),
              leading: Icon(Icons.settings_rounded),
              onTap: () {},
            ),
            Divider(height: 15),
            ListTile(
                title: Text("Cerrar sesion"),
                leading: Icon(Icons.logout),
                onTap: () => _cerrarSesion(context)),
          ],
        ));
  }

  void _cerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cerrar sesion'),
          content: SingleChildScrollView(
            child: Text('Esta a punto de cerrar sesion\nDesea confirmar esta decisión?'),
          ),
          actions: [
            TextButton(
              child: Text('Confirmar'),
              onPressed: () {
                Provider.of<Auth>(context, listen: false).logout();
                Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);
              },
            ),
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
    /*Provider.of<Auth>(context, listen: false).logout();
    Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (route) => false);*/
  }

  void _verPagosPage(context){
    Navigator.of(context).pushNamed("/pays");
  }
}
