import 'package:flutter/material.dart';

class FormFieldCustom extends StatefulWidget {
  final String hint;
  final Icon icon;
  final TextEditingController controller;
  final FormFieldValidator validator;
  final TextInputType inputType;
  final bool isFrase;
  final bool isSenha;
  final int minLines;
  final int maxLines;
  final bool isPreco;

  FormFieldCustom({
    @required this.hint,
    @required this.icon,
    @required this.controller,
    @required this.validator,
    @required this.inputType,
    this.isFrase = false,
    this.isSenha = false,
    this.minLines = 1,
    this.maxLines = 1,
    this.isPreco = false,
  });

  @override
  _FormFieldCustomState createState() => _FormFieldCustomState();
}

class _FormFieldCustomState extends State<FormFieldCustom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isSenha,
        autocorrect: !widget.isSenha,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textCapitalization: widget.isFrase
            ? TextCapitalization.sentences
            : TextCapitalization.none,
        keyboardType: widget.inputType,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: widget.icon,
          hintText: widget.hint,
          contentPadding:
              EdgeInsets.only(left: 20, top: 12, bottom: 0, right: 0),
        ),
        validator: widget.validator,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
      ),
    );
  }
}
