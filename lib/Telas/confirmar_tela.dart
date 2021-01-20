import 'package:cortai/Controle/horario_controle.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Stores/confirmar_store.dart';
import 'package:cortai/Tiles/confirmar_tile.dart';
import 'package:cortai/Widgets/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:scoped_model/scoped_model.dart';

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
                                                element.id == value);
                                        store.mudaLista(index);
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
                        child: Observer(
                          builder: (context) {
                            var widgets = store.confirmados
                                .map<Widget>((h) => ConfirmarTile(
                                      h,
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
              )
            ],
          );
        } else
          return Center();
      },
    );
  }
}
