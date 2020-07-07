import 'package:agendacabelo/Controle/shared_preferences_controle.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Telas/home_tela.dart';
import 'package:agendacabelo/Telas/login_tela.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashCustom extends StatefulWidget {
  @override
  _SplashCustomState createState() => _SplashCustomState();
}

class _SplashCustomState extends State<SplashCustom> {
  var _permissionStatus = PermissionStatus.undetermined;

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
    if (_permissionStatus.isUndetermined)
      requestPermission(Permission.location);
    if (model.isLogado()) {
      return HomeTela();
    }
    return LoginTela();
  }

  Future<Null> requestPermission(Permission permission) async {
    final status = await permission.request();
    _permissionStatus = status;
    if (_permissionStatus == PermissionStatus.granted)
      await Util.setLocalizacao();
    SharedPreferencesControle.setPermissionStatus(status.index);
  }
}
