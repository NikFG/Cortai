import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  @observable
  String endereco = '';

  @observable
  late PermissionStatus status;

  @action
  setEndereco(String endereco) async {
    if (endereco.isNotEmpty) {
      this.endereco = endereco;
    }
  }

  @computed
  bool get getPermissao => _showTela();

  bool _showTela() {
    if (endereco.isEmpty && (status.isDenied || status.isPermanentlyDenied)) {
      return true;
    }
    return false;
  }
}
