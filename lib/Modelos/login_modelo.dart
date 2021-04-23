import 'dart:io';

import 'package:cortai/Dados/login.dart';
import 'package:cortai/Util/api.dart';
import 'package:cortai/Util/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fss;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scoped_model/scoped_model.dart';

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
  Login? dados;
  String token = "";

  static LoginModelo of(BuildContext context) =>
      ScopedModel.of<LoginModelo>(context);

  @override
  void addListener(VoidCallback listener) async {
    super.addListener(listener);
    await carregarDados();
  }

  void listeners() {
    notifyListeners();
  }

  //Criar conta com email e senha
  void criarContaEmail(
      {required Login login,
      required VoidCallback onSuccess,
      required void onFail(String error)}) async {
    notifyListeners();
    var dio = Dio();

    try {
      FormData formData = new FormData.fromMap(login.toJson());
      var response = await dio.post(_url + "user/create",
          data: formData,
          options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status! <= 500;
              }));
      if (response.statusCode == 201) {
        onSuccess();
      } else if (response.statusCode == 409) {
        onFail(
            "Email já cadastrado, tente fazer o login ou clique em esqueceu sua senha!");
      } else {
        onFail("Erro ao realizar o cadastro, tente novamente!");
      }
    } catch (e) {
      print(e);
      onFail("Ocorreu um erro inesperado, tente novamente!");
    }
  }

  //Login no firebase via email/senha
  void logarEmail(
      {required String email,
      required String senha,
      required VoidCallback onSuccess,
      required VoidCallback onFail,
      required VoidCallback onVerifyEmail}) async {
    isCarregando = true;
    notifyListeners();
    var dio = Dio();
    try {
      FormData formData = FormData.fromMap({"email": email, "password": senha});
      var response = await dio.post(_url + "login",
          data: formData,
          options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status! <= 500;
              }));
      if (response.statusCode == 403) {
        onVerifyEmail();
        isCarregando = false;
        return;
      }
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

  //Login via Google na API
  Future<Null> logarGoogle(VoidCallback onSucess, VoidCallback onFail) async {
    isCarregando = true;
    try {
      var googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication auth =
          await googleUser!.authentication.catchError((e) {
        isCarregando = false;
        throw Exception("Erro ao logar");
      });

      await _salvarDadosUsuarioGoogle(googleUser, auth.accessToken!);
      onSucess();
    } on Exception catch (error) {
      print(error);
      onFail();
      isCarregando = false;
    }
  }

  Future<Null> _salvarDadosUsuarioGoogle(
      GoogleSignInAccount user, String googleToken) async {
    Dio dio = Dio();
    FormData data = FormData.fromMap({
      "email": user.email,
      "token": googleToken,
    });
    var response = await dio.post(_url + "login/google",
        data: data,
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! <= 500;
            }));
    if (response.statusCode != 200) {
      throw Exception(response.data);
    } else
      _salvarDados(
          response.data['user'], response.data['access_token'], googleToken,
          isGoogle: true);
  }

  Future<Null> logout() async {
    Dio dio = Dio();
    await dio.post(Util.url + "auth/logout",
        options: Options(headers: Util.token(token)));
    dados = null;
    token = "";
    await _apagarDados();
    isCarregando = false;
    notifyListeners();
  }

  _salvarDados(Map<String, dynamic> login, String token, String senha,
      {bool isGoogle = false}) {
    this.token = token;
    dados = Login.fromJson(login);
    _storage.write(key: 'login', value: dados!.email);
    if (isGoogle) {
      _storage.write(key: "token", value: senha);
    } else {
      _storage.write(key: 'senha', value: senha);
    }
    _storage.write(key: 'isGoogle', value: isGoogle.toString());
  }

  _apagarDados() async {
    await _storage.deleteAll();
  }

  Future<bool> carregarDados() async {
    isCarregando = true;
    String? email = await _storage.read(key: 'login');
    String? senha = await _storage.read(key: 'senha');
    String? token = await _storage.read(key: "token");
    bool isGoogle = await _storage.read(key: 'isGoogle') == 'true';
    if (email != null && (senha != null || token != null)) {
      Dio dio = Dio();
      late Map<String, dynamic> map;
      if (isGoogle) {
        map = {"email": email, "token": token};
      } else {
        map = {"email": email, "password": senha};
      }
      FormData formData = FormData.fromMap(map);
      String google = isGoogle ? "/google" : "";

      var response = await dio.post(_url + "login" + google,
          data: formData,
          options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status! <= 500;
              }));
      if (response.statusCode != 200) {
        await logout();
        return false;
      }

      _salvarDados(response.data['user'], response.data['access_token'],
          isGoogle ? token! : senha!,
          isGoogle: isGoogle);
    }
    isCarregando = false;
    return true;
  }

  bool isLogado() {
    return token.isNotEmpty;
  }

  Future<bool> recuperarSenha(String email) async {
    Dio dio = Dio();
    var response = await dio.post(_url + "login/reset",
        data: FormData.fromMap({'email': email}),
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! <= 500;
            }));
    return response.statusCode == 200;
  }

  atualizaDados(
      {required String telefone,
      required String nome,
      required String token,
      required VoidCallback onSucess,
      required void onFail(String error)}) async {
    try {
      Api api = Api();
      await api.update(
          _url, {'telefone': telefone, 'nome': nome}, token, dados!.id!);
      dados!.telefone = telefone;
      dados!.nome = nome;
      onSucess();
    } catch (e) {
      String error = e.toString();
      // e.forEach((k, v) {
      //   error +=
      //       v.toString().replaceFirst('[', '').replaceFirst(']', '') + "\n";
      // });
      onFail(error);
    }
  }

  atualizaImagem(
      {required File file,
      required VoidCallback onSucess,
      required void onFail(String error)}) async {
    Dio dio = Dio();
    var imagem = await MultipartFile.fromFile(file.path,
        filename: file.path.split('/').last);
    var response = await dio.post(_url + "edit/imagem/" + dados!.id.toString(),
        data: FormData.fromMap({'imagem': imagem}),
        options: Options(
            headers: Util.token(token),
            followRedirects: false,
            validateStatus: (status) {
              return status! <= 500;
            }));
    if (response.statusCode == 201) {
      await carregarDados();
      onSucess();
    } else {
      onFail("erro encontrado");
    }
  }
}
