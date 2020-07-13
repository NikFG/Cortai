import 'package:agendacabelo/Dados/login_dados.dart';
import 'package:agendacabelo/Widgets/custom_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
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
  bool _botaoHabilitado = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
        title: Text("Cadastrar cabeleireiro"),
        centerTitle: true,
      )),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            CustomFormField(
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
              height: 10,
            ),
            Container(
              height: 45,
              child: RaisedButton(
                color: Color(0xFFf45d27),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                onPressed: _botaoHabilitado
                    ? () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _botaoHabilitado = false;
                          });
                          await Firestore.instance
                              .collection('usuarios')
                              .where('email', isEqualTo: _emailControlador.text)
                              .getDocuments()
                              .then((value) async {
                            LoginDados dados = LoginDados.fromMap(
                                value.documents[0].data);

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
    await FlushbarHelper.createError(
            title: "Verifique o email digitado",
            message: "Houve um erro ao enviar o email")
        .show(context);
    setState(() {
      _botaoHabilitado = true;
    });
  }
}
