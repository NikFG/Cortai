import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool _botaoHabilitado = true;
    String _botaoName = "Botao";
    return  SizedBox(
              height: 46,
              width: MediaQuery.of(context).size.width / 1.1,
              child: RaisedButton(
                onPressed: (){},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)),
                child: _botaoHabilitado
                    ? Text(
                        _botaoName,
                        style: TextStyle(fontSize: 18),
                      )
                    : CircularProgressIndicator(),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
              ),
            );
  }
}
