import 'dart:convert';

import 'package:cortai/Controle/galeria_controle.dart';
import 'package:cortai/Dados/galeria.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Tiles/galeria_tile.dart';
import 'package:cortai/Util/util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

class GaleriaTela extends StatefulWidget {
  final int salaoId;

  GaleriaTela(this.salaoId);

  @override
  _GaleriaTelaState createState() => _GaleriaTelaState();
}

class _GaleriaTelaState extends State<GaleriaTela> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData deviceInfo = MediaQuery.of(context);
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Galeria de Barber Shop'),
              leading: Util.leadingScaffold(context),
            ),

            //  backgroundColor: Theme.of(context).primaryColor,
            body: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: deviceInfo.size.width * 2 / 100,
                  vertical: deviceInfo.size.height * 2 / 100),
              child: FutureBuilder<http.Response>(
                future: http.get(GaleriaControle.get(widget.salaoId),
                    headers: Util.token(model.token)),
                builder: (context, response) {
                  if (!response.hasData) {
                    return CircularProgressIndicator();
                  } else {
                    List<dynamic> dados = json.decode(response.data!.body);
                    print(dados);
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: dados.length,
                      itemBuilder: (context, index) {
                        Galeria galeria = Galeria.fromJson(dados[index]);
                        return GaleriaTile(galeria);
                      },
                    );
                  }
                },
              ),
            ));
      },
    );
  }
}
