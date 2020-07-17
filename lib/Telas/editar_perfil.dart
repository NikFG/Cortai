import 'dart:io';
import 'package:agendacabelo/Controle/salao_controle.dart';
import 'package:agendacabelo/Dados/salao.dart';
import 'package:agendacabelo/Util/util.dart';
import 'package:agendacabelo/Widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:password_strength/password_strength.dart';

class EditarPerfilTela extends StatefulWidget {
  EditarPerfilTela();

  @override
  _EditarPerfilTelaState createState() => _EditarPerfilTelaState();
}

class _EditarPerfilTelaState extends State<EditarPerfilTela> {
  final _nomeControlador = TextEditingController();
  final _telefoneControlador = MaskedTextController(mask: '(00) 0 0000-0000');
  final _senhaControlador = TextEditingController();
  final _senhaConfirmaControlador = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Perfil"),
        centerTitle: true,
        leading: Util.leadingScaffold(context),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Nome completo",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.grey,
                    )),
                SizedBox(height: 5),
                CustomFormField(
                    hint:
                        "se tiver como pegar o nome do sujeito no banco fica topster",
                    icon: Icon(
                      FontAwesome.user,
                      color: Colors.grey,
                    ),
                    inputType: TextInputType.emailAddress,
                    controller: _nomeControlador,
                    validator: (text) {
                      return null;
                    }),
                SizedBox(height: 5),
                Text("Telefone",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.grey,
                    )),
                SizedBox(height: 5),
                CustomFormField(
                    hint: "(99)9 9999-9999",
                    icon: Icon(
                      FontAwesome.phone,
                      color: Colors.grey,
                    ),
                    controller: _telefoneControlador,
                    inputType: TextInputType.phone,
                    validator: (text) {
                      if (text.isEmpty || text.length < 11) {
                        return "Numero invalido";
                      }
                      return null;
                    }),
                SizedBox(height: 5),
                Text("Senha",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.grey,
                    )),
                SizedBox(height: 5),
                CustomFormField(
                    hint: "**********",
                    icon: Icon(
                      FontAwesome.lock,
                      color: Colors.grey,
                    ),
                    controller: _senhaControlador,
                    validator: (text) {
                      double forcaSenha =
                          estimatePasswordStrength(_senhaControlador.text);
                      if (text.length < 6) {
                        return "A senha deve conter pelo menos 6 caracteres";
                      }
                      if (forcaSenha < 0.3) {
                        return "Senha fraca, digite uma senha mais forte";
                      }
                      return null;
                    },
                    inputType: TextInputType.visiblePassword,
                    isSenha: true),
                SizedBox(height: 5),
                Text("Confirmar nova Senha",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.grey,
                    )),
                SizedBox(height: 5),
                CustomFormField(
                    hint: "**********",
                    icon: Icon(
                      FontAwesome.lock,
                      color: Colors.grey,
                    ),
                    controller: _senhaConfirmaControlador,
                    validator: (text) {
                      if (text != _senhaControlador.text) {
                        return "As senhas estão diferentes";
                      }
                      return null;
                    },
                    inputType: TextInputType.visiblePassword,
                    isSenha: true),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              height: 45,
              width: MediaQuery.of(context).size.width / 1.2,
              child: RaisedButton(
                  color: Color(0xFFf45d27),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  onPressed: () {},
                  child: Text(
                    'Confirmar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
