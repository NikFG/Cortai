import 'package:agendacabelo/Controle/salao_controle.dart';
import 'package:agendacabelo/Dados/salao_dados.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Telas/cadastro_funcionamento_tela.dart';
import 'package:agendacabelo/Telas/editar_salao_tela.dart';
import 'package:agendacabelo/Telas/login_tela.dart';
import 'package:agendacabelo/Telas/solicitacao_cabeleireiro_tela.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class GerenciarSalaoTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<LoginModelo>(
      model: LoginModelo(),
      child: ScopedModelDescendant<LoginModelo>(
        builder: (context, child, model) {
          if (model.dados != null)
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            CadastroFuncionamentoTela(model.dados.salao)));
                  },
                  child: Text("Horário de funcionamento"),
                ),
                Divider(
                  color: Colors.black45,
                ),
                FlatButton(
                  onPressed: () async {

                    var salaoDados = await SalaoControle.get()
                        .document(model.dados.salao)
                        .get()
                        .then((doc) {
                      return SalaoDados.fromDocument(doc);
                    });
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditarSalaoTela(model.dados.id,
                            salao: salaoDados)));
                  },
                  child: model.dados.salao != null
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
                            SolicitacaoCabeleireiroTela(model.dados.salao)));
                  },
                  child: Text("Cadastrar cabeleireiros"),
                ),
                Divider(
                  color: Colors.black45,
                ),
                FlatButton(
                  onPressed: () async {
                    await model.signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginTela()));
                  },
                  child: Text("Logout"),
                )
              ],
            );
          else
            return Center();
        },
      ),
    );
  }
}
