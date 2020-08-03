import 'package:cortai/Dados/horario.dart';
import 'package:cortai/Dados/login.dart';
import 'package:cortai/Dados/servico.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Stores/agendado_store.dart';
import 'package:cortai/Tiles/agendado_tile.dart';
import 'package:cortai/Widgets/custom_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:scoped_model/scoped_model.dart';

class AgendadoTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AgendadoStore jsonFalse = AgendadoStore();
    AgendadoStore jsonTrue = AgendadoStore();
    return ScopedModelDescendant<LoginModelo>(builder: (context, child, model) {
      if (model.dados != null) {
        final url =
            'https://us-central1-cortai-349b0.cloudfunctions.net/getAgendados'
            '?clienteId=${model.dados.id}&pago=';
        jsonFalse.getData(url + 'false');
        jsonTrue.getData(url + 'true');
        return TabBarView(
          children: <Widget>[
            Tab(
              child: Observer(
                builder: (context) {
                  if (jsonFalse.isLoading) {
                    return CustomShimmer(4);
                  } else {
                    return RefreshIndicator(
                      displacement: MediaQuery.of(context).size.width / 2,
                      color: Theme.of(context).primaryColor,
                      onRefresh: () => jsonFalse.getData(url + 'false'),
                      child: jsonFalse.statusCode == 404
                          ? ListView(
                              physics: AlwaysScrollableScrollPhysics(),
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          4),
                                  child: Text(
                                    jsonFalse.data[0],
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            )
                          : ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: jsonFalse.data.length,
                              itemBuilder: (context, index) {
                                var dado = jsonFalse.data[index];
                                return AgendadoTile(
                                    horario: Horario.fromJson(dado),
                                    servico: Servico.fromHorarioJson(dado),
                                    cabeleireiro: Login.fromHorarioJson(dado),
                                    pago: false);
                              }),
                    );
                  }
                },
              ),
            ),
            Tab(
              child: Observer(
                builder: (context) {
                  if (jsonTrue.isLoading) {
                    return CustomShimmer(4);
                  } else {
                    return RefreshIndicator(
                      displacement: MediaQuery.of(context).size.width / 2,
                      color: Theme.of(context).primaryColor,
                      onRefresh: () => jsonTrue.getData(url + 'true'),
                      child: jsonTrue.statusCode == 404
                          ? ListView(
                              physics: AlwaysScrollableScrollPhysics(),
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          4),
                                  child: Text(
                                    jsonTrue.data[0],
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            )
                          : ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: jsonTrue.count,
                              itemBuilder: (context, index) {
                                var dado = jsonTrue.data[index];
                                return AgendadoTile(
                                    horario: Horario.fromJson(dado),
                                    servico: Servico.fromHorarioJson(dado),
                                    cabeleireiro: Login.fromHorarioJson(dado),
                                    avaliado: dado['avaliado'] as bool,
                                    pago: true);
                              }),
                    );
                  }
                },
              ),
            ),
          ],
        );
      } else {
        return Center();
      }
    });
  }

/*ListView lista(AsyncSnapshot<QuerySnapshot> snapshot, BuildContext context) {
    var dividedTiles = ListTile.divideTiles(
            tiles: snapshot.data.documents.map((doc) {
              return MarcadoTile(HorarioDados.fromDocument(doc));
            }).toList(),
            color: Colors.grey[500],
            context: context)
        .toList();
    return ListView(children: dividedTiles);
  }*/
}
