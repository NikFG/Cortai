import 'package:flutter/material.dart';

class CustomFormField extends StatefulWidget {
  final String hint;
  final Icon icon;
  final TextEditingController controller;
  final FormFieldValidator validator;
  final TextInputType inputType;
  final bool isNome;
  final bool isSenha;
  final int minLines;
  final int maxLines;

  CustomFormField({
    @required this.hint,
    @required this.icon,
    @required this.controller,
    @required this.validator,
    @required this.inputType,
    this.isNome = false,
    this.isSenha = false,
    this.minLines = 1,
    this.maxLines = 1,
  });

  @override
  _CustomFormFieldState createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
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
        autovalidate: widget.controller.text.isNotEmpty,
        textCapitalization: widget.isNome
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
