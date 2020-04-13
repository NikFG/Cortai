import 'package:agendacabelo/Telas/login_tela.dart';
import 'package:flutter/material.dart';
import 'Telas/home_tela.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Agendamento de corte",
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: Color.fromARGB(255, 255, 113, 0),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeTela(),
    );
  }
}
