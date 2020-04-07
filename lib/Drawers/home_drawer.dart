import 'package:agendacabelo/Telas/cabelereiros_tela.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.timer),
              title: Text('Agendar'),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new CabelereirosTela()));
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.search),
              title: Text('Consultar horários'),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new CabelereirosTela()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
