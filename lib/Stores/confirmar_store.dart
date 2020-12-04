import 'dart:async';
import 'dart:convert';

import 'package:cortai/Dados/horario.dart';
import 'package:cortai/Util/util.dart';

import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';

part 'confirmar_store.g.dart';

class ConfirmarStore = _ConfirmarStore with _$ConfirmarStore;

abstract class _ConfirmarStore with Store {
  @observable
  ObservableList<Horario> confirmados = ObservableList<Horario>();

  @observable
  ObservableList<Horario> naoConfirmados = ObservableList<Horario>();

  @observable
  bool isLoading = false;

  @observable
  int statusCode = 400;

  @action
  Future<void> getData(String url, String token) async {
    List<dynamic> data = [];
    isLoading = true;
    var response = await http.get(url, headers: Util.token(token));
    statusCode = response.statusCode;
    print(response.body);
    data = json.decode(response.body);
    data.forEach((element) {
      if (element['confirmado'] == 1) {
        confirmados.add(Horario.fromJson(element));
      } else {
        naoConfirmados.add(Horario.fromJson(element));
      }
    });
    // horarios =
    //     data.map<Horario>((h) => Horario.fromJson(h)).toList().asObservable();
    isLoading = false;
  }

  @computed
  int get contConfirmados => confirmados.length;

  @computed
  int get contNaoConfirmados => naoConfirmados.length;

  @action
  void mudaLista(int index) {
    Horario h = naoConfirmados[index];
    naoConfirmados.remove(h);
    h.confirmado = true;
    confirmados.add(h);
  }
}
