import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class SolicitacaoCabeleireiroTela extends StatelessWidget {
  final String salao;
  var _emailControlador = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  SolicitacaoCabeleireiroTela(this.salao);

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
                    List<DocumentSnapshot> cabeleireiro =
                        value.documents.toList();
                    String uid = cabeleireiro[0].data['uid'];
                    await Firestore.instance
                        .collection('usuarios')
                        .document(uid)
                        .updateData(({'salao': salao}));
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
}
