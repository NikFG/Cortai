import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Telas/editar_salao_tela.dart';
import 'package:agendacabelo/Telas/home_tela.dart';
import 'package:agendacabelo/Telas/login_tela.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashCustom extends StatefulWidget {
  @override
  _SplashCustomState createState() => _SplashCustomState();
}

class _SplashCustomState extends State<SplashCustom> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LoginModelo>(
      builder: (BuildContext context, Widget child, LoginModelo model) {
        return SplashScreen(
          seconds: 4,
          navigateAfterSeconds: _telaInicial(model),
          title: Text("CortaÍ"),
          image: Image.network(
              'https://cdn2.iconfinder.com/data/icons/mosaicon-11/512/cut-512.png'),
          backgroundColor: Theme.of(context).primaryColor,
        );
      },
    );
  }

  Widget _telaInicial(LoginModelo model) {
    if (model.isLogado()) {
      if (model.dados.isDonoSalao != null && model.dados.salao == null) {
        return EditarSalaoTela(model.dados.id);
      } else {
        return HomeTela(usuarioId: model.dados.id);
      }
    }
    return LoginTela();
  }
}
