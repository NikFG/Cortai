import 'package:cortai/Controle/horario_controle.dart';
import 'package:cortai/Dados/horario.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Stores/confirmar_store.dart';
import 'package:cortai/Tiles/confirmar_tile.dart';
import 'package:cortai/Widgets/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_mobx/flutter_mobx.dart';

class ConfirmarTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConfirmarStore store = ConfirmarStore();
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        if (model.dados != null) {
          store.getData(HorarioControle.getCabeleireiroAux(), model.token);
          return TabBarView(
            children: <Widget>[
              Tab(
                child: Observer(builder: (context) {
                  if (store.isLoading) {
                    return CustomShimmer(4);
                  } else {
                    return RefreshIndicator(
                        displacement: MediaQuery.of(context).size.width / 2,
                        color: Theme.of(context).primaryColor,
                        onRefresh: () => store.getData(
                            HorarioControle.getCabeleireiroAux(), model.token),
                        // child: store.statusCode == 200?
                        child: Observer(
                          builder: (context) {
                            var widgets = store.naoConfirmados
                                .map<Widget>((h) => ConfirmarTile(
                                      h,
                                      confirmadoChanged: (int value) {
                                        int index = store.naoConfirmados
                                            .indexWhere((element) =>
                                                element.id == h.id);
                                        store.teste(index);
                                      },
                                    ))
                                .toList();
                            return ListView(
                              physics: AlwaysScrollableScrollPhysics(),
                              children: widgets,
                            );
                          },
                        ));
                  }
                }),
              ),
              Tab(
                child: Observer(builder: (context) {
                  if (store.isLoading) {
                    return CustomShimmer(4);
                  } else {
                    return RefreshIndicator(
                        displacement: MediaQuery.of(context).size.width / 2,
                        color: Theme.of(context).primaryColor,
                        onRefresh: () => store.getData(
                            HorarioControle.getCabeleireiroAux(), model.token),
                        child: store.statusCode == 200
                            ? ListView.builder(
                                physics: AlwaysScrollableScrollPhysics(),
                                itemCount: store.contConfirmados,
                                itemBuilder: (context, index) {
                                  return ConfirmarTile(
                                      store.confirmados[index]);
                                })
                            : ListView(
                                physics: AlwaysScrollableScrollPhysics(),
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height /
                                                4),
                                    child: Text(
                                      "Sem dados a confirmar",
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ));
                  }
                }),
              )
/*
              Tab(
                child: Observer(builder: (context) {
                  if (store.isLoading) {
                    return CustomShimmer(4);
                  } else {
                    return RefreshIndicator(
                      displacement: MediaQuery.of(context).size.width / 2,
                      color: Theme.of(context).primaryColor,
                      onRefresh: () => store.getData(
                          HorarioControle.getCabeleireiroAux()),
                      child: jsonTrue.statusCode == 404
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
                              itemCount: jsonTrue.data.length,
                              itemBuilder: (context, index) {
                                var dado = jsonTrue.data[index];
                                var horario = Horario.fromJson(dado);
                                return ConfirmarTile(horario);
                              }),
                    );
                  }
                }),
              )
*/
/*              FutureBuilder<http.Response>(
                  future: http.get(
                      HorarioControle.getCabeleireiro('cabeleireiro', 0),
                      headers: Util.token(model.token)),
                  builder: (context, response) {
                    if (!response.hasData) {
                      return CustomShimmer(4);
                    } else {
                      if (response.data.body == '[]') {
                        return Center(
                          child: Text("Não há agendamentos para confirmar"),
                        );
                      }
                      List<Horario> listaConfirmar =
                          jsonDecode(response.data.body)
                              .map<Horario>((h) => Horario.fromJson(h))
                              .toList();
                      return ListView.builder(
                        itemCount: listaConfirmar.length,
                        itemBuilder: (context, index) {
                          Horario horario = listaConfirmar[index];

                          return ConfirmarTile(horario);
                        },
                      );
                    }
                  })*/
/*              FutureBuilder<http.Response>(
                  future: http.get(
                      HorarioControle.getCabeleireiro('cabeleireiro', 1),
                      headers: Util.token(model.token)),
                  builder: (context, response) {
                    if (!response.hasData) {
                      return CustomShimmer(4);
                    } else {
                      if (response.data.body == '[]') {
                        return Center(
                          child: Text("Não há agendamentos para confirmar"),
                        );
                      }
                      var listaConfirmar = jsonDecode(response.data.body)
                          .map<Horario>((h) => Horario.fromJson(h))
                          .toList();
                      return ListView.builder(
                        itemCount: listaConfirmar.length,
                        itemBuilder: (context, index) {
                          Horario horario = listaConfirmar[index];
                          return ConfirmarTile(horario);
                        },
                      );
                    }
                  })*/
            ],
          );
        } else
          return Center();
      },
    );
  }
}
