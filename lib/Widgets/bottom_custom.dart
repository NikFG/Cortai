import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:cortai/Util/pusher_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;

class BottomCustom extends StatefulWidget {
  final PageController pageController;
  final int index;
  final bool isCabeleireiro;
  final String usuario;

  BottomCustom(
      this.pageController, this.index, this.isCabeleireiro, this.usuario);

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
    pusher.firePusher(
        eventName: 'ContaConfirmar', channelName: 'user.' + widget.usuario);
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
      BottomNavigationBarItem(
        icon: Icon(FontAwesome.user_circle_o),
        label: "Perfil",
      ),
    ];
    this.itens.addAll(itens);
  }

  itensCabeleireiro(String uid) {
    var itens = [
      BottomNavigationBarItem(
        icon: StreamBuilder(
          stream: pusher.eventStream,
          builder: (context, snapshot) {
            print("chegou aqui");
            if (!snapshot.hasData) {
              http
                  .get('http://192.168.0.108:8000/api/agenda/9')
                  .then((value) => value);

              return Icon(FontAwesome5.calendar_check);
            } else {
              var dados = json.decode(snapshot.data);
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
