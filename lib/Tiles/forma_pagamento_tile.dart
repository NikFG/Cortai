import 'package:cortai/Dados/forma_pagamento.dart';
import 'package:flutter/material.dart';

class FormaPagamentoTile extends StatefulWidget {
  final FormaPagamento pagamento;
  final int salaoId;
  final ValueChanged<FormaChecked> onFormasChanged;
  final bool selected;

  const FormaPagamentoTile(
      {required this.pagamento,
      required this.salaoId,
      required this.onFormasChanged,
      this.selected = false});

  @override
  _FormaPagamentoTileState createState() => _FormaPagamentoTileState();
}

class _FormaPagamentoTileState extends State<FormaPagamentoTile> {
  late FormaChecked _formaChecked;

  @override
  void initState() {
    _formaChecked = FormaChecked(false, widget.pagamento.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: _formaChecked.checked,
      title: Text(widget.pagamento.descricao),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _formaChecked.checked = value;
            widget.onFormasChanged(_formaChecked);
          });
        }
      },
    );
  }
}

class FormaChecked {
  bool checked;
  int id;

  FormaChecked(this.checked, this.id);
}
