import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String textoBotao;
  final bool botaoHabilitado;
  final VoidCallback onPressed;

  CustomButton(
      {@required this.textoBotao,
      @required this.botaoHabilitado,
      @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      width: MediaQuery.of(context).size.width / 1.1,
      child: RaisedButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.red)),
        child: botaoHabilitado
            ? Text(
                this.textoBotao,
                style: TextStyle(fontSize: 18),
              )
            : CircularProgressIndicator(),
        textColor: Colors.white,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
