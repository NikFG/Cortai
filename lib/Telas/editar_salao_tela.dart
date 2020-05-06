import 'package:agendacabelo/Dados/salao_dados.dart';
import 'package:agendacabelo/Telas/home_tela.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';

class EditarSalao extends StatefulWidget {
  final String salao;
  final String usuario;

  EditarSalao(this.usuario, this.salao);

  @override
  _EditarSalaoState createState() => _EditarSalaoState();
}

class _EditarSalaoState extends State<EditarSalao> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _enderecoController = TextEditingController();
  SalaoDados dados = SalaoDados();

  @override
  Widget build(BuildContext context) {
    verificaSalao();
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar salão"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(30),
          children: <Widget>[
            TextFormField(
              controller: _nomeController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                  hintText: 'Nome', hintStyle: TextStyle(fontSize: 12)),
            ),
            TextFormField(
              controller: _enderecoController,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              autocorrect: true,
              decoration: InputDecoration(
                  hintText: 'Endereço completo',
                  hintStyle: TextStyle(fontSize: 12)),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 40,
              width: 20,
              child: RaisedButton(
                padding: EdgeInsets.all(8),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    dados.nome = _nomeController.text;
                    dados.endereco = _enderecoController.text;
                    if (dados.id == null) {
                      await Firestore.instance
                          .collection('saloes')
                          .add(dados.toMap())
                          .then((doc) async {
                        await FlushbarHelper.createSuccess(
                          message: "Salão criado com sucesso",
                        ).show(context);
                        Firestore.instance
                            .collection('usuarios')
                            .document(widget.usuario)
                            .updateData({'salao': widget.salao});
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomeTela()));
                      }).catchError((e) {
                        FlushbarHelper.createError(
                                message:
                                    'Houve algum erro ao criar o salão\nTente novamente!!')
                            .show(context);
                      });
                    } else {
                      await Firestore.instance
                          .collection('saloes')
                          .document(dados.id)
                          .updateData(dados.toMap())
                          .then((doc) async {
                        await FlushbarHelper.createSuccess(
                          message: "Salão modificado com sucesso",
                        ).show(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomeTela()));
                      }).catchError((e) {
                        FlushbarHelper.createError(
                                message:
                                    'Houve algum erro ao editar o salão\nTente novamente!!')
                            .show(context);
                      });
                    }
                  }
                },
                child: Text(
                  "Confirmar",
                  style: TextStyle(fontSize: 18),
                ),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> verificaSalao() async {
    await Firestore.instance
        .collection('saloes')
        .document(widget.salao)
        .get()
        .then((doc) {
      if (doc.data.length > 0) {
        dados = SalaoDados.fromDocument(doc);
        _nomeController.text = dados.nome;
        _enderecoController.text = dados.endereco;
      }
    });
  }
}
