import 'package:agendacabelo/Dados/preco_dados.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:scoped_model/scoped_model.dart';

class ServicoTela extends StatefulWidget {
  @override
  _ServicoTelaState createState() => _ServicoTelaState();
}

class _ServicoTelaState extends State<ServicoTela> {
  final _formKey = GlobalKey<FormState>();
  final _nomeControlador = TextEditingController();
  final _precoControlador = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$');

  @override
  Widget build(BuildContext context) {
    return ScopedModel<LoginModelo>(
      model: LoginModelo(),
      child: ScopedModelDescendant<LoginModelo>(
          //TODO: EDITAR SERVIÇO e forma de apagar virtualmente
          builder: (context, child, model) {
        return Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: <Widget>[
              TextFormField(
                controller: _nomeControlador,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(hintText: "Nome do serviço"),
                // ignore: missing_return
                validator: (text) {
                  if (text.isEmpty) {
                    return "Nome inválido";
                  }
                },
              ),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: _precoControlador,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "Preço do serviço"),
                // ignore: missing_return
                validator: (text) {
                  if (text.isEmpty) {
                    return "Preço inválido";
                  }
                  if (text == "R\$0,00") {
                    return "Preço não pode ser zero";
                  }
                },
              ),
              SizedBox(height: 25),
              SizedBox(
                  height: 44,
                  child: RaisedButton(
                    child: Text(
                      "Cadastrar",
                      style: TextStyle(fontSize: 18),
                    ),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        PrecoDados dados = PrecoDados();
                        dados.descricao = _nomeControlador.text;
                        print(_precoControlador.text);

                        dados.setValor(_precoControlador.text);

//                        Firestore.instance
//                            .collection("usuarios")
//                            .document(model.usuarioData['uid'])
//                            .collection('precos')
//                            .add(dados.toMap());
                      }
                    },
                  ))
            ],
          ),
        );
      }),
    );
  }
}
