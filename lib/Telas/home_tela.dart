import 'package:agendacabelo/Tiles/home_tab.dart';
import 'package:agendacabelo/Telas/gerenciar_salao_tela.dart';
import 'package:agendacabelo/Util/push_notification.dart';
import 'package:agendacabelo/Widgets/bottom_custom.dart';
import 'package:agendacabelo/Widgets/drawer_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'marcado_tela.dart';
import 'criar_servico_tela.dart';
import 'confirmar_tela.dart';

class HomeTela extends StatefulWidget {
  final String usuario_id;
  final int paginaInicial;

  HomeTela({this.usuario_id, this.paginaInicial});

  @override
  _HomeTelaState createState() => _HomeTelaState();
}

class _HomeTelaState extends State<HomeTela> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final _pageController = PageController(
        initialPage:
            widget.paginaInicial == null ? index : widget.paginaInicial);
    if (widget.usuario_id != null)
      PushNotification.servico(widget.usuario_id, context);
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _pageController,
      onPageChanged: (i) {
        setState(() {
          index = i;
        });
      },
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text("Home"),
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
          ),
          body: HomeTab(),
//          bottomNavigationBar: BottomCustom(_pageController, index),
          bottomNavigationBar: BottomCustom(_pageController, index),
        ),
        Scaffold(
          bottomNavigationBar: BottomCustom(_pageController, index),
          body: MarcadoTela(),
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("Horários marcados"),
            centerTitle: true,
          ),
        ),
        Scaffold(
          bottomNavigationBar: BottomCustom(_pageController, index),
          body: ConfirmarTela(),
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("Confirmar horários"),
            centerTitle: true,
            actions: <Widget>[
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: FlatButton(
                      onPressed: () async {
                        var snapshots = await Firestore.instance
                            .collection('servicos')
                            .getDocuments();

                        for (int i = 0; i < snapshots.documents.length; i++) {
                          Firestore.instance
                              .collection('servicos')
                              .document(snapshots.documents[i].documentID)
                              .updateData({
                            "confirmado": true,
                          });
                        }
                      },
                      child: Text("Confirmar todos"),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: FlatButton(
                      onPressed: () {},
                      child: Text("Cancelar todos"),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Scaffold(
          bottomNavigationBar: BottomCustom(_pageController, index),
          body: CriarServicoTela(),
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("Cadastrar serviços"),
            centerTitle: true,
          ),
        ),
        Scaffold(
          bottomNavigationBar: BottomCustom(_pageController, index),
          body: GerenciarSalaoTela(),
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text("Gerenciar salão"),
            centerTitle: true,
          ),
        ),
      ],
    );
  }
}
