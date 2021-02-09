import 'dart:async';
import 'dart:convert';

import 'package:cortai/Util/util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';

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
  Future<void> getData(String url, {@required String token}) async {
    isLoading = true;
    var response = await http.get(url, headers: Util.token(token));
    statusCode = response.statusCode;
    if (statusCode == 404) {
      data = json.decode(response.body);
    } else {
      data = json.decode(response.body)['horarios'];
    }
    isLoading = false;
  }

  @computed
  int get count => data.length;
}
