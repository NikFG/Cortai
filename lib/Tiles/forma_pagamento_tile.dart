import 'package:agendacabelo/Dados/forma_pagamento_dados.dart';
import 'package:flutter/material.dart';

class FormaPagamentoTile extends StatelessWidget {
  final FormaPagamentoDados dados;

  FormaPagamentoTile(this.dados);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        //passar para a próxima tela o id da forma de pagamento (dados.id)
      },
      leading: Image.network(
        dados.icone,
        height: 50,
        width: 50,
      ),
      title: Text(dados.descricao),
    );
  }
}