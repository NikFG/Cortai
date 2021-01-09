// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirmar_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$ConfirmarStore on _ConfirmarStore, Store {
  Computed<int> _$contConfirmadosComputed;

  @override
  int get contConfirmados =>
      (_$contConfirmadosComputed ??= Computed<int>(() => super.contConfirmados,
              name: '_ConfirmarStore.contConfirmados'))
          .value;
  Computed<int> _$contNaoConfirmadosComputed;

  @override
  int get contNaoConfirmados => (_$contNaoConfirmadosComputed ??= Computed<int>(
          () => super.contNaoConfirmados,
          name: '_ConfirmarStore.contNaoConfirmados'))
      .value;

  final _$confirmadosAtom = Atom(name: '_ConfirmarStore.confirmados');

  @override
  ObservableList<Horario> get confirmados {
    _$confirmadosAtom.reportRead();
    return super.confirmados;
  }

  @override
  set confirmados(ObservableList<Horario> value) {
    _$confirmadosAtom.reportWrite(value, super.confirmados, () {
      super.confirmados = value;
    });
  }

  final _$naoConfirmadosAtom = Atom(name: '_ConfirmarStore.naoConfirmados');

  @override
  ObservableList<Horario> get naoConfirmados {
    _$naoConfirmadosAtom.reportRead();
    return super.naoConfirmados;
  }

  @override
  set naoConfirmados(ObservableList<Horario> value) {
    _$naoConfirmadosAtom.reportWrite(value, super.naoConfirmados, () {
      super.naoConfirmados = value;
    });
  }

  final _$isLoadingAtom = Atom(name: '_ConfirmarStore.isLoading');

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

  final _$statusCodeAtom = Atom(name: '_ConfirmarStore.statusCode');

  @override
  int get statusCode {
    _$statusCodeAtom.reportRead();
    return super.statusCode;
  }

  @override
  set statusCode(int value) {
    _$statusCodeAtom.reportWrite(value, super.statusCode, () {
      super.statusCode = value;
    });
  }

  final _$getDataAsyncAction = AsyncAction('_ConfirmarStore.getData');

  @override
  Future<void> getData(String url, String token) {
    return _$getDataAsyncAction.run(() => super.getData(url, token));
  }

  final _$_ConfirmarStoreActionController =
      ActionController(name: '_ConfirmarStore');

  @override
  void mudaLista(int index) {
    final _$actionInfo = _$_ConfirmarStoreActionController.startAction(
        name: '_ConfirmarStore.mudaLista');
    try {
      return super.mudaLista(index);
    } finally {
      _$_ConfirmarStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
confirmados: ${confirmados},
naoConfirmados: ${naoConfirmados},
isLoading: ${isLoading},
statusCode: ${statusCode},
contConfirmados: ${contConfirmados},
contNaoConfirmados: ${contNaoConfirmados}
    ''';
  }
}
