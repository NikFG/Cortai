import 'dart:async';
import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:http/http.dart' as http;

part 'agendado_store.g.dart';

class AgendadoStore = _AgendadoStore with _$AgendadoStore;

abstract class _AgendadoStore with Store {
  @observable
  List<dynamic> data = [];

  @observable
  bool isLoading = false;

  @observable
  int statusCode = 400;

  @action
  Future<void> getData(url) async {
    isLoading = true;
    var response = await http.get(url);
    statusCode = response.statusCode;
    if (statusCode == 404) {
      data.add(response.body);
    } else
      data = json.decode(response.body);
    isLoading = false;
  }

  @computed
  int get count => data.length;
}
