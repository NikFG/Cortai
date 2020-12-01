import 'dart:async';
import 'dart:convert';

import 'package:cortai/Dados/horario.dart';
import 'package:cortai/Util/pusher_service.dart';
import 'package:cortai/Util/util.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;

part 'agenda_store.g.dart';

class AgendaStore = _AgendaStore with _$AgendaStore;

abstract class _AgendaStore with Store {
  _AgendaStore() {
    _pusher = PusherService();
    stream = ObservableStream(_pusher.eventStream);
  }

  PusherService _pusher;

  @observable
  List<Horario> horarios = [];

  @observable
  List<String> horariosTela = [];


  @observable
  bool isLoading = false;

  @observable
  ObservableStream stream;

  @computed
  bool get isEmpty => horarios.isEmpty;

  @action
  bool horarioOcupado(String horario){
    return horariosTela.contains(horario);
  }

  @action
  Future<void> getData(String url, String token) async {
    isLoading = true;
    var response = await http.get(url, headers: Util.token(token));
    var statusCode = response.statusCode;
    if (statusCode == 404) {
      print("erro");
    } else {
      var data = json.decode(response.body);
      horarios = data.map<Horario>((h) => Horario.fromJson(h)).toList();
    }
    isLoading = false;
  }

  @action
  Future<void> firePusher(int cabeleireiro, String token) async {
    await _pusher.firePusher(
        channelName: 'private-agenda.${cabeleireiro.toString()}',
        eventName: 'AgendaCabeleireiro',
        token: token);
  }

  @action
  void unbindEvent(String eventName) {
    _pusher.unbindEvent(eventName);
  }

  @action
  void updateList(List<Horario> dados) {
    this.horarios = dados;
  }

  /*
  * Cria o vetor de itens de horários disponíveis
  * */
  @action
  void itensHorario(
      {@required String abertura,
      @required String fechamento,
      @required int intervalo,
      @required DateTime horarioAtual}) {
    DateTime inicial = Util.timeFormat.parse(abertura);
    DateTime atual = Util.timeFormat.parse(abertura);
    DateTime fecha = Util.timeFormat.parse(fechamento);
    List<String> listaHorarios = [];
    while (atual.isBefore(fecha)) {
      //cria com todos horários possíveis
      listaHorarios.add(Util.timeFormat.format(atual));
      atual = atual.add(Duration(minutes: intervalo));
    }
    if (horarioAtual != null)
      while (horarioAtual.isAfter(inicial)) {
        //remove os horários que já existem no dia
        listaHorarios.remove(Util.timeFormat.format(inicial));
        inicial = inicial.add(Duration(minutes: intervalo));
      }
    if (horarios.length > 0) {
      for (var dado in horarios) {
        listaHorarios.remove(dado.hora);
      }
    }

    horariosTela = listaHorarios;
  }
}
