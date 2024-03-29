// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeStore on _HomeStore, Store {
  Computed<bool>? _$getPermissaoComputed;

  @override
  bool get getPermissao =>
      (_$getPermissaoComputed ??= Computed<bool>(() => super.getPermissao,
              name: '_HomeStore.getPermissao'))
          .value;

  final _$enderecoAtom = Atom(name: '_HomeStore.endereco');

  @override
  String get endereco {
    _$enderecoAtom.reportRead();
    return super.endereco;
  }

  @override
  set endereco(String value) {
    _$enderecoAtom.reportWrite(value, super.endereco, () {
      super.endereco = value;
    });
  }

  final _$latitudeAtom = Atom(name: '_HomeStore.latitude');

  @override
  String? get latitude {
    _$latitudeAtom.reportRead();
    return super.latitude;
  }

  @override
  set latitude(String? value) {
    _$latitudeAtom.reportWrite(value, super.latitude, () {
      super.latitude = value;
    });
  }

  final _$longitudeAtom = Atom(name: '_HomeStore.longitude');

  @override
  String? get longitude {
    _$longitudeAtom.reportRead();
    return super.longitude;
  }

  @override
  set longitude(String? value) {
    _$longitudeAtom.reportWrite(value, super.longitude, () {
      super.longitude = value;
    });
  }

  final _$statusAtom = Atom(name: '_HomeStore.status');

  @override
  PermissionStatus? get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(PermissionStatus? value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  final _$setEnderecoAsyncAction = AsyncAction('_HomeStore.setEndereco');

  @override
  Future setEndereco(String endereco) {
    return _$setEnderecoAsyncAction.run(() => super.setEndereco(endereco));
  }

  @override
  String toString() {
    return '''
endereco: ${endereco},
latitude: ${latitude},
longitude: ${longitude},
status: ${status},
getPermissao: ${getPermissao}
    ''';
  }
}
