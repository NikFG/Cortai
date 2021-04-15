import 'package:cortai/Controle/shared_preferences_controle.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Util/util.dart';
import 'package:cortai/Widgets/form_field_custom.dart';
import 'package:email_validator/email_validator.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'cadastro_tela.dart';
import 'index_tela.dart';

class LoginTela extends StatefulWidget {
  @override
  _LoginTelaState createState() => _LoginTelaState();
}

class _LoginTelaState extends State<LoginTela> {
  final _formKey = GlobalKey<FormState>();
  final _emailControlador = TextEditingController();
  final _senhaControlador = TextEditingController();
  bool _botaoHabilitado = true;

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    Util.corPrimariaStatusBar(context);
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        if (model.isCarregando) {
          return Scaffold(
              body: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Carregando...",
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(
                  height: 10,
                ),
                CircularProgressIndicator(),
              ],
            ),
          ));
        } else {
          return Scaffold(
              body: Form(
            key: _formKey,
            child: IgnorePointer(
              ignoring: !_botaoHabilitado,
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: deviceInfo.size.width,
                          height: 30.5,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Theme.of(context).primaryColor,
                                  Theme.of(context).accentColor
                                ],
                              ),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.elliptical(250, 100),
                                  bottomRight: Radius.elliptical(250, 100))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Spacer(),
                              Align(
                                alignment: Alignment.center,
                                child: Image(
                                  image: AssetImage(
                                    'assets/icons/icon_white_transparent.png',
                                  ),
                                  height: 30.0,
                                  width: 30.0,
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Container(
                          width: deviceInfo.size.width,
                          padding: EdgeInsets.only(top: 62),
                          child: Column(
                            children: <Widget>[
                              FormFieldCustom(
                                  hint: "Email",
                                  icon: Icon(
                                    Icons.email,
                                    color: Colors.grey,
                                  ),
                                  inputType: TextInputType.emailAddress,
                                  controller: _emailControlador,
                                  validator: (text) {
                                    if (text.isEmpty) {
                                      return "O email não pode estar em branco";
                                    }
                                    if (!EmailValidator.validate(text)) {
                                      return "O email digitado está incorreto";
                                    }
                                    return null;
                                  }),
                              SizedBox(
                                height: 15,
                              ),
                              FormFieldCustom(
                                controller: _senhaControlador,
                                inputType: TextInputType.visiblePassword,
                                icon: Icon(
                                  Icons.vpn_key,
                                  color: Colors.grey,
                                ),
                                hint: "Senha",
                                isSenha: true,
                                validator: (text) {
                                  if (text.isEmpty || text.length < 1) {
                                    return "Senha inválida";
                                  }
                                  return null;
                                },
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 16, right: 32),
                                  child: ButtonTheme(
                                    padding: EdgeInsets.zero,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    minWidth: 0,
                                    child: TextButton(
                                      onPressed: () async {
                                        if (_emailControlador.text.isNotEmpty) {
                                          bool result =
                                              await model.recuperarSenha(
                                                  _emailControlador.text);
                                          if (result) {
                                            await FlushbarHelper.createInformation(
                                                    message:
                                                        "Verifique seu email para recuperar a senha!")
                                                .show(context);
                                          } else {
                                            await FlushbarHelper.createError(
                                                    message:
                                                        "Houve algum erro ao recuperar sua senha, digite seu email novamente!")
                                                .show(context);
                                          }
                                        } else {
                                          await FlushbarHelper.createInformation(
                                                  message:
                                                      "Digite seu email para recuperar a senha!")
                                              .show(context);
                                        }
                                      },
                                      child: Text('Esqueceu a senha ?',
                                          style: TextStyle(color: Colors.grey)),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 45,
                                width: deviceInfo.size.width / 1.2,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _botaoHabilitado = false;
                                      });
                                      model.logarEmail(
                                          email: _emailControlador.text,
                                          senha: _senhaControlador.text,
                                          onSuccess: onSuccess,
                                          onFail: onFail,
                                          onVerifyEmail: onVerifyEmail);
                                    }
                                  },
                                  child: _botaoHabilitado
                                      ? Text(
                                          'Login',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFf45d27),
                                    shape: const BeveledRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.grey),
                                child: Center(
                                  child: Text(
                                    'OU',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextButton(
                                onPressed: () async {
                                  setState(() {
                                    _botaoHabilitado = false;
                                  });
                                  await model.logarGoogle(onSuccess, onFail);
                                },
                                child: Text("Entre com o Google"),
                              ),
                              Container(
                                child: Center(
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CadastroTela()));
                                      },
                                      child: Text(
                                        'Não tem cadastro ? Cadastre-se',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontFamily: 'Roboto'),
                                      )),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
        }
      },
    );
  }

  void onSuccess() async {
    await FlushbarHelper.createSuccess(message: "Login realizado com sucesso")
        .show(context);
    if (SharedPreferencesControle.getPermissionStatus() ==
        PermissionStatus.granted) await Util.setLocalizacao();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => IndexTela()));
  }

  void onFail() async {
    await FlushbarHelper.createError(
            message: "Erro ao realizar o login, tente novamente!",
            title: "Verifique os dados digitados")
        .show(context);
    setState(() {
      _botaoHabilitado = true;
    });
  }

  void onVerifyEmail() {
    FlushbarHelper.createInformation(
            title: "Verifique seu email antes de fazer login!",
            message: "Olhe sua caixa de entrada e seu spam!")
        .show(context);
    setState(() {
      _botaoHabilitado = true;
    });
  }
}
