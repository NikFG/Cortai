import 'dart:convert';

import 'package:cortai/Controle/servico_controle.dart';
import 'package:cortai/Dados/salao.dart';
import 'package:cortai/Dados/servico.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Telas/saiba_mais.dart';
import 'package:cortai/Tiles/servico_tile.dart';
import 'package:cortai/Util/util.dart';
import 'package:cortai/Widgets/custom_appbar.dart';
import 'package:cortai/Widgets/custom_appbar_expandida.dart';
import 'package:cortai/Widgets/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:sizer/sizer.dart';

import 'galeria_tela.dart';

class ServicoTela extends StatelessWidget {
  final Salao salao;
  final String distancia;

  ServicoTela({@required this.salao, @required this.distancia});

  @override
  Widget build(BuildContext context) {
    String media = salao.quantidadeAvaliacao > 0
        ? salao.mediaAvaliacao.toStringAsFixed(1)
        : '0.0';
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
              backgroundColor: Colors.white,
              leading: Util.leadingScaffold(context),
              title: CustomAppbar(
                  child: Text(
                salao.nome,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0.sp,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              )),
              stretch: false,
              pinned: true,
              centerTitle: true,
              expandedHeight: 90.0,
              flexibleSpace: FlexibleSpaceBar(
                background: CustomAppbarExpandida(
                    nomeSalao: salao.nome,
                    enderecoSalao: salao.endereco,
                    menorValor: salao.menorValorServico,
                    maiorValor: salao.maiorValorServico,
                    distancia: distancia),
              )),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SaibaMaisTela(salao)));
                        },
                        child: Row(
                          //  mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 2.1,
                              child: Text(
                                salao.nome,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontSize: 20.0.sp),
                                maxLines: 2,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              alignment: Alignment.bottomRight,
                              padding: EdgeInsets.only(right: 1.0.h),
                              child: FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GaleriaTela(salao.id)));
                                  },
                                  child: Text("Galeria >",
                                      style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontSize: 13.0.sp,
                                      ))),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 2.0.h),
                    Container(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SaibaMaisTela(salao)));
                            },
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: 2.0.h,
                                          left: 1.0.h,
                                          right: 1.0.h),
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              child: Text(
                                                "$distancia",
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 14.0.sp,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        bottom: 2.0.h,
                                        left: 1.0.h,
                                        right: 1.0.h),
                                    child: Text(
                                      "R\$${salao.menorValorServico.toStringAsFixed(2)}"
                                      " - "
                                      "R\$${salao.maiorValorServico.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14.0.sp,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(bottom: 2.0.h),
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(width: 1.0.w),
                                        Icon(Icons.star,
                                            color: Colors.amberAccent,
                                            size: 14.0.sp),
                                        Text(
                                          media,
                                          style: TextStyle(
                                            fontSize: 14.0.sp,
                                            color: Colors.amber,
                                          ),
                                        ),
                                        Icon(FontAwesome.angle_right),
                                      ],
                                    ),
                                  ),
                                ]))),
                  ],
                ),
              ),
              ScopedModelDescendant<LoginModelo>(
                builder: (context, child, model) {
                  return FutureBuilder<http.Response>(
                    future: http.get(ServicoControle.getBySalao(this.salao.id),
                        headers: Util.token(model.token)),
                    builder: (context, response) {
                      if (!response.hasData) {
                        return CustomShimmer(4);
                      } else {
                        print(response.data.body);
                        List<dynamic> dados = json.decode(response.data.body);
                        var widgets = dados
                            .map((doc) => ServicoTile(
                                Servico.fromJsonApi(doc), this.salao.nome))
                            .toList();
                        return Column(
                          children: widgets,
                        );
                      }
                    },
                  );
                },
              )
            ]),
          ),
        ],
      ),
    );
  }
}
