import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cortai/Controle/horario_controle.dart';
import 'package:cortai/Util/pusher_service.dart';
import 'package:cortai/Util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;

class BottomCustom extends StatefulWidget {
  final PageController pageController;
  final int index;
  final bool isCabeleireiro;
  final int usuario;
  final String token;

  BottomCustom(this.pageController, this.index, this.isCabeleireiro,
      this.usuario, this.token);

  @override
  _BottomCustomState createState() => _BottomCustomState();
}

class _BottomCustomState extends State<BottomCustom> {
  List<BottomNavigationBarItem> itens = [];
  PusherService pusher = PusherService();

  @override
  void initState() {
    itensUsuario();
    if (widget.isCabeleireiro) {
      itensCabeleireiro(widget.usuario);
    }
    itens.add(BottomNavigationBarItem(
      icon: Icon(FontAwesome.user_circle_o),
      label: "Perfil",
    ));

    pusher.firePusher(
        eventName: 'ContaConfirmar',
        channelName: 'private-conta.' + widget.usuario.toString(),
        token: widget.token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.index,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      onTap: (index) {
        _bottomTapped(index);
      },
      items: itens,
    );
  }

  void _bottomTapped(int index) {
    setState(() {
      widget.pageController.jumpToPage(index);
    });
  }

  itensUsuario() {
    var itens = [
      BottomNavigationBarItem(
        icon: Icon(FontAwesome.home),
        label: "Início",
      ),
      BottomNavigationBarItem(
        icon: Icon(FontAwesome.calendar_o),
        label: "Agenda",
      ),
    ];
    this.itens.addAll(itens);
  }

  itensCabeleireiro(int id) {
    var itens = [
      BottomNavigationBarItem(
        icon: StreamBuilder(
          stream: pusher.eventStream,
          builder: (context, event) {
            print("chegou aqui");
            if (!event.hasData) {
              return FutureBuilder<http.Response>(
                future: http.get(HorarioControle.getQuantidade(id),
                    headers: Util.token(widget.token)),
                builder: (context, response) {
                  if (!response.hasData) {
                    return Icon(FontAwesome5.calendar_check);
                  } else {
                    var dados = json.decode(response.data!.body);
                    int numeroConfirmacoes = dados['quantidade'];
                    return Badge(
                      badgeColor: Theme.of(context).primaryColor,
                      showBadge: numeroConfirmacoes != 0,
                      animationType: BadgeAnimationType.scale,
                      position: BadgePosition(bottom: 8, start: 12),
                      badgeContent: Text(
                        numeroConfirmacoes.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      child: Icon(FontAwesome5.calendar_check),
                    );
                  }
                },
              );
            } else {
              var dados = json.decode(event.data.toString());
              int numeroConfirmacoes = dados['quantidade'];

              return Badge(
                badgeColor: Theme.of(context).primaryColor,
                showBadge: numeroConfirmacoes != 0,
                animationType: BadgeAnimationType.scale,
                position: BadgePosition(bottom: 8, start: 12),
                badgeContent: Text(
                  numeroConfirmacoes.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                child: Icon(FontAwesome5.calendar_check),
              );
            }
          },
        ),
        label: "Confirmar",
      ),
      BottomNavigationBarItem(
        icon: Icon(FontAwesome.scissors),
        label: "Serviços",
      ),
    ];
    this.itens.addAll(itens);
  }

  @override
  void dispose() {
    pusher.unbindEvent('ContaConfirmar');
    super.dispose();
  }
}
