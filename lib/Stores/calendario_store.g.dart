// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendario_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CalendarioStore on _CalendarioStore, Store {
  Computed<bool>? _$isHojeEmptyComputed;

  @override
  bool get isHojeEmpty =>
      (_$isHojeEmptyComputed ??= Computed<bool>(() => super.isHojeEmpty,
              name: '_CalendarioStore.isHojeEmpty'))
          .value;
  Computed<bool>? _$isSeteEmptyComputed;

  @override
  bool get isSeteEmpty =>
      (_$isSeteEmptyComputed ??= Computed<bool>(() => super.isSeteEmpty,
              name: '_CalendarioStore.isSeteEmpty'))
          .value;
  Computed<bool>? _$isMesEmptyComputed;

  @override
  bool get isMesEmpty =>
      (_$isMesEmptyComputed ??= Computed<bool>(() => super.isMesEmpty,
              name: '_CalendarioStore.isMesEmpty'))
          .value;

  final _$horariosHojeAtom = Atom(name: '_CalendarioStore.horariosHoje');

  @override
  List<Horario> get horariosHoje {
    _$horariosHojeAtom.reportRead();
    return super.horariosHoje;
  }

  @override
  set horariosHoje(List<Horario> value) {
    _$horariosHojeAtom.reportWrite(value, super.horariosHoje, () {
      super.horariosHoje = value;
    });
  }

  final _$horariosSeteAtom = Atom(name: '_CalendarioStore.horariosSete');

  @override
  List<Horario> get horariosSete {
    _$horariosSeteAtom.reportRead();
    return super.horariosSete;
  }

  @override
  set horariosSete(List<Horario> value) {
    _$horariosSeteAtom.reportWrite(value, super.horariosSete, () {
      super.horariosSete = value;
    });
  }

  final _$horariosMesAtom = Atom(name: '_CalendarioStore.horariosMes');

  @override
  List<Horario> get horariosMes {
    _$horariosMesAtom.reportRead();
    return super.horariosMes;
  }

  @override
  set horariosMes(List<Horario> value) {
    _$horariosMesAtom.reportWrite(value, super.horariosMes, () {
      super.horariosMes = value;
    });
  }

  final _$isLoadingAtom = Atom(name: '_CalendarioStore.isLoading');

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

  final _$filtraDataAsyncAction = AsyncAction('_CalendarioStore.filtraData');

  @override
  Future<Null> filtraData(Uri uri, String token) {
    return _$filtraDataAsyncAction.run(() => super.filtraData(uri, token));
  }

  @override
  String toString() {
    return '''
horariosHoje: ${horariosHoje},
horariosSete: ${horariosSete},
horariosMes: ${horariosMes},
isLoading: ${isLoading},
isHojeEmpty: ${isHojeEmpty},
isSeteEmpty: ${isSeteEmpty},
isMesEmpty: ${isMesEmpty}
    ''';
  }
}
