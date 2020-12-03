import 'package:cortai/Dados/login.dart';
import 'package:cortai/Util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fss;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:dio/dio.dart';

/*
* Classe modelo para ScopedModel.
* Gravar as sessões e os dados de login para serem usados em qualquer parte do código.
* */
class LoginModelo extends Model {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/user.phonenumbers.read'
  ]);
  final String _url = Util.url + "auth/";
  final _storage = fss.FlutterSecureStorage();

  bool isCarregando = false;
  Login dados;
  String token = "";

  static LoginModelo of(BuildContext context) =>
      ScopedModel.of<LoginModelo>(context);

  @override
  void addListener(VoidCallback listener) async {
    super.addListener(listener);
    await carregarDados();
  }

  void teste() {
    notifyListeners();
  }

  //Criar conta com email e senha
  void criarContaEmail(
      {@required Login login,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    notifyListeners();
    var dio = Dio();

    try {
      FormData formData = new FormData.fromMap(login.toMap());
      var response = await dio.post(_url + "user/create", data: formData);
      if (response.statusCode == 200)
        onSuccess();
      else
        onFail();
    } catch (e) {
      print(e);
      onFail();
    }
  }

  //Login no firebase via email/senha
  void signInEmail(
      {@required String email,
      @required String senha,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail,
      @required VoidCallback onVerifyEmail}) async {
    isCarregando = true;
    notifyListeners();
    var dio = Dio();
    try {
      FormData formData = FormData.fromMap({"email": email, "password": senha});
      var response = await dio.post(_url + "login", data: formData);
      print(response.data);
      isCarregando = false;
      _salvarDados(response.data['user'], response.data['access_token'], senha);
      notifyListeners();
      onSuccess();
    } catch (e) {
      print(e);
      isCarregando = false;
      onFail();
    }
  }

  //Login no firebase via Google
  Future<Null> logarGoogle(VoidCallback onSucess, VoidCallback onFail) async {
    isCarregando = true;
    try {
      var googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication auth =
          await googleUser.authentication.catchError((e) => null);
      if (googleUser == null) {
        isCarregando = false;
        throw Exception("Erro ao logar");
      }
      _salvarDadosUsuarioGoogle(googleUser, auth.accessToken);
      onSucess();
    } catch (error) {
      print(error);
      onFail();
      isCarregando = false;
    }
  }

  Future<Null> _salvarDadosUsuarioGoogle(
      GoogleSignInAccount user, String google_token) async {
    Login login = Login(
      nome: user.displayName,
      email: user.email,
      imagem: user.photoUrl,
      senha: google_token,
      isCabeleireiro: false,
      salaoId: null,
      isDonoSalao: false,
      isGoogle: true,
    );
    try {
      Dio dio = Dio();
      FormData data = FormData.fromMap(login.toMap());
      var response = await dio.post(_url + "login/google", data: data);

      _salvarDados(
          response.data['user'], response.data['access_token'], google_token);
    } catch (e) {
      print(e);
    }
  }

  Future<Null> logout() async {
    Dio dio = Dio();
    await dio.post(Util.url + "auth/logout",
        options: Options(headers: Util.token(token)));
    dados = null;
    token = null;
    await _apagarDados();
    notifyListeners();
  }

  _salvarDados(Map<String, dynamic> login, String token, String senha,
      {bool isGoogle = false}) {
    this.token = token;
    dados = Login.fromJson(login);
    _storage.write(key: 'login', value: dados.email);
    _storage.write(key: 'senha', value: senha);
    _storage.write(key: 'isGoogle', value: isGoogle.toString());
  }

  _apagarDados() async {
    await _storage.deleteAll();
  }

  Future<Null> carregarDados() async {
    isCarregando = true;
    String email = await _storage.read(key: 'login');
    String senha = await _storage.read(key: 'senha');
    bool isGoogle = await _storage.read(key: 'isGoogle') == 'true';
    if (email != null && senha != null) {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({"email": email, "password": senha});
      String google = isGoogle ? "/google" : "";

      var response = await dio.post(_url + "login" + google, data: formData);
      _salvarDados(response.data['user'], response.data['access_token'], senha);
    }
    isCarregando = false;
  }

  bool isLogado() {
    return token.isNotEmpty;
  }

  Future<bool> recuperarSenha(String email) async {
    Dio dio = Dio();
    var response = await dio.post(_url + "login/reset",
        data: FormData.fromMap({'email': email}));
    print(response.data);
    return response.statusCode == 200;
  }

  atualizaDados(
      {@required String telefone,
      @required String nome,
      @required String token,
      @required VoidCallback onSucess,
      @required VoidCallback onFail}) async {
    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        'telefone': telefone,
        'nome': nome,
      });
      var response = await dio.post(_url + "edit/${dados.id}",
          data: formData,
          options: Options(
            headers: Util.token(token),
          ));
      if (response.statusCode == 200) {
        dados.telefone = telefone;
        dados.nome = nome;
        onSucess();
      } else
        onFail();
    } catch (e) {
      print(e);
      onFail();
    }
  }
}
