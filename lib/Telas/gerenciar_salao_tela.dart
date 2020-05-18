import 'package:agendacabelo/Dados/salao_dados.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Telas/cadastro_funcionamento_tela.dart';
import 'package:agendacabelo/Telas/editar_salao_tela.dart';
import 'package:agendacabelo/Telas/solicitacao_cabeleireiro_tela.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'editar_servico_tela.dart';

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
                      builder: (context) => CadastroFuncionamentoTela()));
                },
                child: Text("Horário de funcionamento"),
              ),
              Divider(
                color: Colors.black45,
              ),
              FlatButton(
                onPressed: () async {

                  var salaoDados = await Firestore.instance
                      .collection('saloes')
                      .document(model.getSalao())
                      .get().then((doc) {
                        return SalaoDados.fromDocument(doc);
                  });
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditarSalaoTela(
                          model.dados['uid'], salao: salaoDados)));
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
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          SolicitacaoCabeleireiroTela(model.getSalao())));
                },
                child: Text("Cadastrar cabeleireiros"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          EditarServicoTela(model.getSalao())));
                },
                child: Text("Editar Serviço"),
              )
            ],
          );
        },
      ),
    );
  }
}
