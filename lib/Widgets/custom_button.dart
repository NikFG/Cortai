import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:sizer/sizer.dart';

class CustomButton extends StatelessWidget {
  final String textoBotao;
  final bool botaoHabilitado;
  final VoidCallback onPressed;

  CustomButton({
    @required this.textoBotao,
    @required this.botaoHabilitado,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46, // 46 ;)
      width: MediaQuery.of(context).size.width / 1.1,
      child: RaisedButton(
        onPressed: onPressed,
        child: botaoHabilitado
            ? Text(
                this.textoBotao,
                style: TextStyle(fontSize: 14.0.sp),
              )
            : JumpingDotsProgressIndicator(
                fontSize: 25.0.sp,
              ),
        textColor: Colors.white,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
