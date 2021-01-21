import 'package:cortai/Controle/shared_preferences_controle.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Telas/home_tela.dart';
import 'package:cortai/Tiles/start_screen.dart';
import 'package:cortai/Util/util.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:sizer/sizer.dart';

class SplashCustom extends StatefulWidget {
  final bool logado;

  SplashCustom(this.logado);

  @override
  _SplashCustomState createState() => _SplashCustomState();
}

class _SplashCustomState extends State<SplashCustom> {
  var _permissionStatus = PermissionStatus.undetermined;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LoginModelo>(
      builder: (BuildContext context, Widget child, LoginModelo model) {
        requestPermission(Permission.notification);
        if (_permissionStatus.isUndetermined)
          requestPermission(Permission.location);

        return SplashScreen(
          seconds: 5,
          navigateAfterSeconds: _telaInicial(model),
          //   title: Text("CortaÍ"),
          image: Image.asset('assets/icons/icon_white_transparent.png'),
          photoSize: 30.0.w,
          useLoader: false,
          loaderColor: Colors.white,
          backgroundColor: Theme
              .of(context)
              .primaryColor,
        );
      },
    );
  }

  Widget _telaInicial(LoginModelo model) {
    if (widget.logado) {
      model.carregarDados();
      return HomeTela();
    } else {
      return StartScreen();
    }
  }

  Future<Null> requestPermission(Permission permission) async {
    final status = await permission.request();
    _permissionStatus = status;
    if (_permissionStatus == PermissionStatus.granted)
      await Util.setLocalizacao();
    SharedPreferencesControle.setPermissionStatus(status.index);
  }
}
