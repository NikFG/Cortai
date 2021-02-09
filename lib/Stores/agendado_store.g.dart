// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agendado_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AgendadoStore on _AgendadoStore, Store {
  Computed<int> _$countComputed;

  @override
  int get count => (_$countComputed ??=
          Computed<int>(() => super.count, name: '_AgendadoStore.count'))
      .value;

  final _$dataAtom = Atom(name: '_AgendadoStore.data');

  @override
  List<dynamic> get data {
    _$dataAtom.reportRead();
    return super.data;
  }

  @override
  set data(List<dynamic> value) {
    _$dataAtom.reportWrite(value, super.data, () {
      super.data = value;
    });
  }

  final _$isLoadingAtom = Atom(name: '_AgendadoStore.isLoading');

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

  final _$statusCodeAtom = Atom(name: '_AgendadoStore.statusCode');

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

  final _$getDataAsyncAction = AsyncAction('_AgendadoStore.getData');

  @override
  Future<void> getData(String url, {@required String token}) {
    return _$getDataAsyncAction.run(() => super.getData(url, token: token));
  }

  @override
  String toString() {
    return '''
data: ${data},
isLoading: ${isLoading},
statusCode: ${statusCode},
count: ${count}
    ''';
  }
}
