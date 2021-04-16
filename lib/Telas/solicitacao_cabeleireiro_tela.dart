import 'package:cortai/Controle/salao_controle.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Widgets/button_custom.dart';
import 'package:cortai/Widgets/form_field_custom.dart';
import 'package:email_validator/email_validator.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'index_tela.dart';

class SolicitacaoCabeleireiroTela extends StatefulWidget {
  SolicitacaoCabeleireiroTela();

  @override
  _SolicitacaoCabeleireiroTelaState createState() =>
      _SolicitacaoCabeleireiroTelaState();
}

class _SolicitacaoCabeleireiroTelaState
    extends State<SolicitacaoCabeleireiroTela> {
  final _emailControlador = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _botaoHabilitado = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
        title: Text("Cadastrar cabeleireiro"),
        centerTitle: true,
      )),
      body: ScopedModelDescendant<LoginModelo>(
        builder: (context, child, model) {
          return Form(
            key: _formKey,
            child: IgnorePointer(
              ignoring: !_botaoHabilitado,
              child: ListView(
                padding: EdgeInsets.all(10),
                children: <Widget>[
                  FormFieldCustom(
                    controller: _emailControlador,
                    icon: Icon(Icons.mail),
                    hint: "Email",
                    inputType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text.isEmpty || !EmailValidator.validate(text)) {
                        return "Email inválido";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  ButtonCustom(
                    textoBotao: 'Confirmar',
                    botaoHabilitado: _botaoHabilitado,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _botaoHabilitado = false;
                        });
                        await SalaoControle.adicionaCabeleireiro(
                            email: _emailControlador.text,
                            token: model.token,
                            onSuccess: onSuccess,
                            onFail: onFail);
                      }
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  onSuccess() async {
    await FlushbarHelper.createSuccess(message: "Email enviado com sucesso")
        .show(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => IndexTela()));
  }

  onFail() async {
    await FlushbarHelper.createError(
            title: "Verifique o email digitado",
            message: "Houve um erro ao enviar o email")
        .show(context);
    setState(() {
      _botaoHabilitado = true;
    });
  }
}
