import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Telas/login_tela.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Telas/home_tela.dart';

void main() => runApp(MyApp());

//Todo tutorial primeira entrada!
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<LoginModelo>(
        model: LoginModelo(),
        child: ScopedModelDescendant<LoginModelo>(
          builder: (context, child, model) {
            return MaterialApp(
              title: "Agendamento de corte",
              theme: ThemeData(
                primarySwatch: Colors.orange,
                primaryColor: Colors.deepOrange,
              ),
              debugShowCheckedModeBanner: false,
              home: model.isLogado() ? HomeTela() : LoginTela(),
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('pt'),
              ],
            );
          },
        ));
  }
}
