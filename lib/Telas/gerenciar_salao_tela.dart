import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Telas/editar_salao_tela.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class CreateSalaoTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<LoginModelo>(
      model: LoginModelo(),
      child: ScopedModelDescendant<LoginModelo>(
        builder: (context, child, model) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          EditarSalao(model.dados['uid'], model.getSalao())));
                },
                child: model.getSalao() != null
                    ? Text("Editar salão")
                    : Text("Criar salão"),
              ),
              Divider(
                color: Colors.black45,
              ),
              FlatButton(
                onPressed: () {},
                child: Text("Relatórios"),
              ),
              Divider(
                color: Colors.black45,
              ),
              FlatButton(
                onPressed: () {},
                child: Text("Cadastrar cabelereiros"),
              ),
            ],
          );
        },
      ),
    );
  }
}
