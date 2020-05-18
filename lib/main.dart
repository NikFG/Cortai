import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/maps_tela.dart';
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
                primaryColor: Color(0xFFf45d27),
                accentColor: Color(0xFFf5851f),
              ),
              debugShowCheckedModeBanner: false,
                home: model.isLogado()
                  ? HomeTela(
                      usuario_id: model.dados['uid'],
                    )
                  : HomeTela(),
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
