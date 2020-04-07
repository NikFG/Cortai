import 'package:agendacabelo/Drawers/home_drawer.dart';
import 'package:flutter/material.dart';

class HomeTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        title: const Text('Agendamento de corte'),
      ),
      body: Center(
          child: Text('Você tem agendamento na segunda com Celminho')
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment Counter',
        child: const Icon(Icons.add),
      ),
    );
  }
}
