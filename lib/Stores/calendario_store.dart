import 'dart:convert';

import 'package:cortai/Dados/horario.dart';
import 'package:cortai/Util/util.dart';
import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';

part 'calendario_store.g.dart';

class CalendarioStore = _CalendarioStore with _$CalendarioStore;

abstract class _CalendarioStore with Store {
  @observable
  List<Horario> horariosHoje = [];

  @observable
  List<Horario> horariosSete = [];

  @observable
  List<Horario> horariosMes = [];

  @observable
  bool isLoading = false;

  @computed
  bool get isHojeEmpty => horariosHoje.isEmpty;

  @computed
  bool get isSeteEmpty => horariosSete.isEmpty;

  @computed
  bool get isMesEmpty => horariosMes.isEmpty;

  @computed
  bool get isAllEmpty => isHojeEmpty && isSeteEmpty && isMesEmpty;

  @action
  Future<Null> filtraData(Uri uri, String token) async {
    isLoading = true;
    List<dynamic> dados = [];
    var response = await http.get(uri, headers: Util.token(token));
    if(response.statusCode==200) {
      dados = json.decode(response.body);
      List<Horario> horarios =
          dados.map<Horario>((h) => Horario.fromJson(h)).toList();
      final agora = DateTime.now();
      final hoje = DateTime(agora.year, agora.month, agora.day);
      final semana = hoje.add(Duration(days: 8));
      final mes = hoje.add(Duration(days: 7));

      horariosHoje = horarios
          .where((element) => Util.dateFormat.parse(element.data!) == hoje)
          .toList();
      horariosSete = horarios.where((element) {
        var data = Util.dateFormat.parse(element.data!);
        return data.isAfter(hoje) && data.isBefore(semana);
      }).toList();
      horariosMes = horarios.where((element) {
        var data = Util.dateFormat.parse(element.data!);
        return data.isAfter(mes);
      }).toList();
    }
    isLoading = false;
  }
}
