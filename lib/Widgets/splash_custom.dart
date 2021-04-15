import 'package:cortai/Controle/shared_preferences_controle.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Telas/index_tela.dart';
import 'package:cortai/Telas/login_tela.dart';
import 'package:cortai/Tiles/start_screen.dart';
import 'package:cortai/Util/util.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class SplashCustom extends StatefulWidget {
  final bool logado;

  SplashCustom(this.logado);

  @override
  _SplashCustomState createState() => _SplashCustomState();
}

class _SplashCustomState extends State<SplashCustom> {
  var _permissionStatus = PermissionStatus.denied;

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    return ScopedModelDescendant<LoginModelo>(
      builder: (BuildContext? context, Widget? child, LoginModelo model) {
        requestPermission(Permission.notification);
        if (_permissionStatus.isDenied) requestPermission(Permission.location);

        return AnimatedSplashScreen.withScreenFunction(
          splash: 'assets/icons/icon_white.png',
          splashIconSize: deviceInfo.size.width / 2,
          screenFunction: () async {
            return _telaInicial(model);
          },
          splashTransition: SplashTransition.fadeTransition,
        );
      },
    );
  }

  Widget _telaInicial(LoginModelo model) {
    if (widget.logado) {
      model.carregarDados();
      return IndexTela();
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
