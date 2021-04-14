import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Widgets/splash_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sizer/sizer.dart';

import 'Controle/shared_preferences_controle.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesControle.getInstace();
  bool logado = await FlutterSecureStorage().containsKey(key: "senha") || await FlutterSecureStorage().containsKey(key: "token");

  runApp(MyApp(logado));
}

//Todo tutorial primeira entrada!
//TODO TRATAR SEM ACESSO A INTERNET PRA LOGAR
class MyApp extends StatelessWidget {
  final bool logado;

  MyApp(this.logado);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      //return LayoutBuilder necessário para o uso da biblioteca Sizer!
      builder: (context, constraints) {
        return OrientationBuilder(
          //return OrientationBuilder necessário para o uso da biblioteca Sizer!
          builder: (context, orientation) {
            //initialize SizerUtil() necessário para o uso da biblioteca Sizer!
            SizerUtil().init(constraints, orientation);
            return ScopedModel<LoginModelo>(
              model: LoginModelo(),
              child: MaterialApp(
                title: "Cortaí",
                theme: ThemeData(
                    primarySwatch: Colors.orange,
                    primaryColor: Color(0xFFf45d27),
                    accentColor: Color(0xFFf5851f),
                    fontFamily: 'Poppins'),
                debugShowCheckedModeBanner: false,
                home: SplashCustom(logado),
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
          },
        );
      },
    );
  }
}
