import 'package:agendacabelo/Telas/login_tela.dart';
import 'package:agendacabelo/login_service.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Telas/home_tela.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<LoginService>(
      model: LoginService(),
      child: ScopedModelDescendant<LoginService>(
        builder: (context,child,model){
          return  MaterialApp(
            title: "Agendamento de corte",
            theme: ThemeData(
              primarySwatch: Colors.orange,
              primaryColor: Color.fromARGB(255, 255, 113, 0),
            ),
            debugShowCheckedModeBanner: true,
            home: HomeTela(),
          );
        },
    )

    );
  }
}
