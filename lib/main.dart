import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Widgets/splash_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Controle/shared_preferences_controle.dart';

void main() => runApp(MyApp());

//Todo tutorial primeira entrada!
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SharedPreferencesControle();
    return ScopedModel<LoginModelo>(
      model: LoginModelo(),
      child: MaterialApp(
        title: "Agendamento de corte",
        theme: ThemeData(
          primarySwatch: Colors.orange,
          primaryColor: Color(0xFFf45d27),
          accentColor: Color(0xFFf5851f),
          fontFamily: 'Poppins'
        ),
        debugShowCheckedModeBanner: false,
        home: SplashCustom(),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('pt'),
        ],
      ),
    );
  }
}
