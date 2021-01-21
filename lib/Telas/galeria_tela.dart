import 'package:cortai/Modelos/login_modelo.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sizer/sizer.dart';

import 'galeria_detalhes_tela.dart';

class GaleriaTela extends StatefulWidget {
  GaleriaTela();

  @override
  _GaleriaTelaState createState() => _GaleriaTelaState();
}

class _GaleriaTelaState extends State<GaleriaTela> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LoginModelo>(
      builder: (context, child, model) {
        return Scaffold(
            appBar: AppBar(
              title: Text('Galeria de Barber Shop'),
            ),
            //  backgroundColor: Theme.of(context).primaryColor,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0.w, vertical: 2.0.h),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return RawMaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalhesGaleria(
                            imagePath: 'assets/images/mala.png',
                            title: 'Corte Brabo',
                            price: '15,00',
                            details:
                                'malaia tem que tomar cuidado com oque escreve porque se escrever muito provavelmente vai dar ruim',
                            index: index,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'logo$index',
                      child: Container(
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                            image: AssetImage('assets/images/mala.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: 12,
              ),
            ));
      },
    );
  }
}
