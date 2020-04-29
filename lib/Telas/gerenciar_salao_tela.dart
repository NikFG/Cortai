
import 'package:flutter/material.dart';


class CreateSalaoTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FlatButton(
          onPressed: (){},
          child: Text("Editar salão"),
        ),
        Divider(color: Colors.black45,),
        FlatButton(
          onPressed: (){},
          child: Text("Relatórios"),
        ),
        Divider(color: Colors.black45,),
        FlatButton(
          onPressed: (){},
          child: Text("Cadastrar cabelereiros"),
        ),

      ],
    );
  }
}
