import 'package:agendacabelo/Dados/login_dados.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';

class SolicitacaoCabeleireiroTela extends StatefulWidget {
  final String salao;

  SolicitacaoCabeleireiroTela(this.salao);

  @override
  _SolicitacaoCabeleireiroTelaState createState() =>
      _SolicitacaoCabeleireiroTelaState();
}

class _SolicitacaoCabeleireiroTelaState
    extends State<SolicitacaoCabeleireiroTela> {
  final _emailControlador = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: (AppBar(
        title: Text("Cadastrar cabeleireiro"),
        centerTitle: true,
      )),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailControlador,
              decoration: InputDecoration(
                  hintText: 'Email', hintStyle: TextStyle(fontSize: 12)),
              validator: (text) {
                if (text.isEmpty || !EmailValidator.validate(text)) {
                  return "Email inválido";
                }
                return null;
              },
            ),
            RaisedButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  await Firestore.instance
                      .collection('usuarios')
                      .where('email', isEqualTo: _emailControlador.text)
                      .getDocuments()
                      .then((value) async {
                    LoginDados dados =
                        LoginDados.fromDocument(value.documents[0].data);

                    await Firestore.instance
                        .collection('usuarios')
                        .document(dados.id)
                        .updateData(({'salaoTemp': widget.salao}));
                    onSuccess();
                  }).catchError((e) {
                    print(e);
                    onFail();
                  });
                }
              },
              child: Text("Confirmar"),
            )
          ],
        ),
      ),
    );
  }

  onSuccess() async {
    await FlushbarHelper.createSuccess(message: "Email enviado com sucesso")
        .show(context);
  }

  onFail() async {
    await FlushbarHelper.createError(message: "Houve um erro ao enviar o email")
        .show(context);
  }
}
