// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AgendaStore on _AgendaStore, Store {
  Computed<bool>? _$isEmptyComputed;

  @override
  bool get isEmpty => (_$isEmptyComputed ??=
          Computed<bool>(() => super.isEmpty, name: '_AgendaStore.isEmpty'))
      .value;

  final _$horariosAtom = Atom(name: '_AgendaStore.horarios');

  @override
  List<Horario> get horarios {
    _$horariosAtom.reportRead();
    return super.horarios;
  }

  @override
  set horarios(List<Horario> value) {
    _$horariosAtom.reportWrite(value, super.horarios, () {
      super.horarios = value;
    });
  }

  final _$horariosTelaAtom = Atom(name: '_AgendaStore.horariosTela');

  @override
  List<String> get horariosTela {
    _$horariosTelaAtom.reportRead();
    return super.horariosTela;
  }

  @override
  set horariosTela(List<String> value) {
    _$horariosTelaAtom.reportWrite(value, super.horariosTela, () {
      super.horariosTela = value;
    });
  }

  final _$isLoadingAtom = Atom(name: '_AgendaStore.isLoading');

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  final _$streamAtom = Atom(name: '_AgendaStore.stream');

  @override
  ObservableStream<dynamic>? get stream {
    _$streamAtom.reportRead();
    return super.stream;
  }

  @override
  set stream(ObservableStream<dynamic>? value) {
    _$streamAtom.reportWrite(value, super.stream, () {
      super.stream = value;
    });
  }

  final _$getDataAsyncAction = AsyncAction('_AgendaStore.getData');

  @override
  Future<void> getData(Uri uri, String token) {
    return _$getDataAsyncAction.run(() => super.getData(uri, token));
  }

  final _$firePusherAsyncAction = AsyncAction('_AgendaStore.firePusher');

  @override
  Future<void> firePusher(int cabeleireiro, String token) {
    return _$firePusherAsyncAction
        .run(() => super.firePusher(cabeleireiro, token));
  }

  final _$_AgendaStoreActionController = ActionController(name: '_AgendaStore');

  @override
  bool horarioOcupado(String horario) {
    final _$actionInfo = _$_AgendaStoreActionController.startAction(
        name: '_AgendaStore.horarioOcupado');
    try {
      return super.horarioOcupado(horario);
    } finally {
      _$_AgendaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void unbindEvent(String eventName) {
    final _$actionInfo = _$_AgendaStoreActionController.startAction(
        name: '_AgendaStore.unbindEvent');
    try {
      return super.unbindEvent(eventName);
    } finally {
      _$_AgendaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateList(List<Horario> dados) {
    final _$actionInfo = _$_AgendaStoreActionController.startAction(
        name: '_AgendaStore.updateList');
    try {
      return super.updateList(dados);
    } finally {
      _$_AgendaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void itensHorario(
      {required String abertura,
      required String fechamento,
      required int intervalo,
      required DateTime? horarioAtual}) {
    final _$actionInfo = _$_AgendaStoreActionController.startAction(
        name: '_AgendaStore.itensHorario');
    try {
      return super.itensHorario(
          abertura: abertura,
          fechamento: fechamento,
          intervalo: intervalo,
          horarioAtual: horarioAtual);
    } finally {
      _$_AgendaStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
horarios: ${horarios},
horariosTela: ${horariosTela},
isLoading: ${isLoading},
stream: ${stream},
isEmpty: ${isEmpty}
    ''';
  }
}
