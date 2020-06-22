import 'package:agendacabelo/Controle/servico_controle.dart';
import 'package:agendacabelo/Modelos/login_modelo.dart';
import 'package:agendacabelo/Tiles/home_tab.dart';
import 'package:agendacabelo/Telas/gerenciar_salao_tela.dart';
import 'package:agendacabelo/Util/push_notification.dart';
import 'package:agendacabelo/Widgets/bottom_custom.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'gerenciar_servico_tela.dart';
import 'marcado_tela.dart';
import 'confirmar_tela.dart';

class HomeTela extends StatefulWidget {
  final String usuarioId;
  final int paginaInicial;

  HomeTela({this.usuarioId, this.paginaInicial});

  @override
  _HomeTelaState createState() => _HomeTelaState();
}

class _HomeTelaState extends State<HomeTela> {
  int index = 0;

  @override
  void initState() {
    super.initState();
    if (widget.paginaInicial != null) {
      index = widget.paginaInicial;
    }
    if (widget.usuarioId != null)
      PushNotification.servico(widget.usuarioId, context);
  }

  @override
  Widget build(BuildContext context) {
    final _pageController = PageController(initialPage: index);
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        print(model.dados);
        return PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              this.index = index;
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
              bottomNavigationBar: BottomCustom(_pageController, index,
                  model.dados.isCabeleireiro, model.dados.id),
            ),
            DefaultTabController(
              length: 2,
              child: Scaffold(
                bottomNavigationBar: BottomCustom(_pageController, index,
                    model.dados.isCabeleireiro, model.dados.id),
                body: MarcadoTela(),
                appBar: AppBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  title: Text("Horários marcados"),
                  centerTitle: true,
                  bottom: TabBar(
                    tabs: <Widget>[
                      Tab(
                        icon: Icon(Icons.content_cut),
                      ),
                      Tab(icon: Icon(Icons.person))
                    ],
                  ),
                ),
              ),
            ),
            Scaffold(
              bottomNavigationBar: BottomCustom(_pageController, index,
                  model.dados.isCabeleireiro, model.dados.id),
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
                            var snapshots =
                                await ServicoControle.get().getDocuments();

                            for (int i = 0;
                                i < snapshots.documents.length;
                                i++) {
                              ServicoControle.get()
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
              bottomNavigationBar: BottomCustom(_pageController, index,
                  model.dados.isCabeleireiro, model.dados.id),
              body: GerenciarServicoTela(),
              appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                title: Text("Gerenciar serviços"),
                centerTitle: true,
              ),
            ),
            Scaffold(
              bottomNavigationBar: BottomCustom(_pageController, index,
                  model.dados.isCabeleireiro, model.dados.id),
              body: GerenciarSalaoTela(),
              appBar: AppBar(
                backgroundColor: Theme.of(context).primaryColor,
                title: Text("Gerenciar salão"),
                centerTitle: true,
              ),
            ),
          ],
        );
      },
    );
  }
}
