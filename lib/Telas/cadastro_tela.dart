import 'package:cortai/Dados/login.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Telas/login_tela.dart';
import 'package:cortai/Util/util.dart';
import 'package:cortai/Widgets/form_field_custom.dart';
import 'package:email_validator/email_validator.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:password_strength/password_strength.dart';

class CadastroTela extends StatefulWidget {
  @override
  _CadastroTelaState createState() => _CadastroTelaState();
}

class _CadastroTelaState extends State<CadastroTela> {
  final _formKey = GlobalKey<FormState>();
  final _emailControlador = TextEditingController();
  final _senhaControlador = TextEditingController();
  final _senhaConfirmaControlador = TextEditingController();
  final _telefoneControlador = MaskedTextController(mask: '(00) 00000-0000');
  final _nomeControlador = TextEditingController();
  bool _botaoHabilitado = true;

  @override
  Widget build(BuildContext context) {
    Util.corPrimariaStatusBar(context);
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
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
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
                          child: Icon(
                            Icons.person,
                            size: 70,
                            color: Colors.white,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            'Cadastre-se',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Color(0xCCFFFFFF),
                              fontSize: 38,
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 30),
                    child: Column(
                      children: <Widget>[
                        FormFieldCustom(
                            hint: "Nome completo",
                            icon: Icon(
                              Icons.person_pin,
                              color: Colors.grey,
                            ),
                            controller: _nomeControlador,
                            isFrase: true,
                            inputType: TextInputType.text,
                            validator: (text) {
                              if (text.isEmpty) {
                                return "O nome não pode estar vazio";
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 15,
                        ),
                        FormFieldCustom(
                            hint: "Email",
                            inputType: TextInputType.emailAddress,
                            icon: Icon(Icons.email, color: Colors.grey),
                            controller: _emailControlador,
                            validator: (text) {
                              if (text.isEmpty ||
                                  !EmailValidator.validate(text)) {
                                return "Email inválido";
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 15,
                        ),
                        FormFieldCustom(
                            hint: "Telefone",
                            icon: Icon(
                              Icons.phone,
                              color: Colors.grey,
                            ),
                            controller: _telefoneControlador,
                            inputType: TextInputType.phone,
                            validator: (text) {
                              if (text.isEmpty || text.length < 11) {
                                return "Numero invalido";
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 15,
                        ),
                        FormFieldCustom(
                            hint: "Senha",
                            icon: Icon(Icons.vpn_key, color: Colors.grey),
                            controller: _senhaControlador,
                            validator: (text) {
                              double forcaSenha = estimatePasswordStrength(
                                  _senhaControlador.text);
                              if (text.length < 6) {
                                return "A senha deve conter pelo menos 6 caracteres";
                              }
                              if (forcaSenha < 0.3) {
                                return "Senha fraca, digite uma senha mais forte";
                              }
                              return null;
                            },
                            inputType: TextInputType.visiblePassword,
                            isSenha: true),
                        SizedBox(
                          height: 15,
                        ),
                        FormFieldCustom(
                            hint: "Confirmar Senha",
                            icon: Icon(Icons.vpn_key, color: Colors.grey),
                            controller: _senhaConfirmaControlador,
                            validator: (text) {
                              if (text != _senhaControlador.text) {
                                return "As senhas estão diferentes";
                              }
                              return null;
                            },
                            inputType: TextInputType.visiblePassword,
                            isSenha: true),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: RaisedButton(
                            color: Color(0xFFf45d27),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            onPressed: _botaoHabilitado
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _botaoHabilitado = false;
                                      });
                                      LoginModelo login = LoginModelo();
                                      var loginDados = Login(
                                          email: _emailControlador.text,
                                          nome: _nomeControlador.text,
                                          telefone: _telefoneControlador.text,
                                          isCabeleireiro: false,
                                          salaoId: null,
                                          imagem: null,
                                          isDonoSalao: false,
                                          senha:
                                              _senhaConfirmaControlador.text);

                                      login.criarContaEmail(
                                          login: loginDados,
                                          onSuccess: onSuccess,
                                          onFail: onFail);
                                    }
                                  }
                                : null,
                            child: _botaoHabilitado
                                ? Text(
                                    'Confirmar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : CircularProgressIndicator(),
                          ),
                        ),
                        Container(
                          child: Center(
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => LoginTela()));
                                },
                                child: Text(
                                  'Já tem cadastro ? Faça Login',
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

  void onSuccess() async {
    await FlushbarHelper.createSuccess(
            title: "Cadastro realizado com sucesso",
            message: "Verifique seu email")
        .show(context);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginTela()));
  }

  void onFail() async {
    await FlushbarHelper.createError(
            message: "Erro ao realizar o cadastro, teste novamente!")
        .show(context);
    setState(() {
      _botaoHabilitado = true;
    });
  }
}
