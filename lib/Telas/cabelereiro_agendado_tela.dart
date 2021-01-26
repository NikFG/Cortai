import 'package:cortai/Controle/horario_controle.dart';
import 'package:cortai/Dados/horario.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Stores/agendado_store.dart';
import 'package:cortai/Tiles/cabelereiro_agendado_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sizer/sizer.dart';

class CabelereiroAgendado extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LoginModelo>(builder: (context, child, model) {
      AgendadoStore jsonFalse = AgendadoStore();
      jsonFalse.getData(HorarioControle.getNew("cliente", 0),
          token: model.token);
      return Observer(builder: (context) {
        if (jsonFalse.isLoading) {
          return Center();
        }
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: AppBar(
              title: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Text(
                    "Agenda Salão",
                    style: TextStyle(fontSize: 18.0.sp, color: Colors.black),
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
              bottomOpacity: 0.0,
              elevation: 0.0,
            ),
          ),
          body: ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: [
              Container(
                padding: EdgeInsets.all(2.0.h),
                child: Text(
                  "Hoje",
                  style: TextStyle(
                    fontSize: 16.0.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Divider(
                height: 5,
                thickness: 2,
                color: Colors.black87,
              ),
              //ListView que carrega as Tiles de HOJE
              ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: jsonFalse.data.length,
                  itemBuilder: (context, index) {
                    var dado = jsonFalse.data[index];
                    var horario = Horario.fromJson(dado);
                    return CabelereiroAgendadoTile(
                      horario: horario,
                      servico: horario.servicos.first,
                      token: model.token,
                    );
                  }),
              Container(
                padding: EdgeInsets.all(2.0.h),
                child: Text(
                  "Essa Semana",
                  style: TextStyle(
                    fontSize: 16.0.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Divider(
                height: 5,
                thickness: 2,
                color: Colors.black87,
              ),
              //ListView que carrega as Tiles dessa SEMANA
              ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: jsonFalse.data.length,
                  itemBuilder: (context, index) {
                    var dado = jsonFalse.data[index];
                    var horario = Horario.fromJson(dado);
                    return CabelereiroAgendadoTile(
                      horario: horario,
                      servico: horario.servicos.first,
                      token: model.token,
                    );
                  }),
              Container(
                padding: EdgeInsets.all(2.0.h),
                child: Text(
                  "Este mês",
                  style: TextStyle(
                    fontSize: 16.0.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Divider(
                height: 5,
                thickness: 2,
                color: Colors.black87,
              ),
              //ListView que carrega as Tiles desse MÊS
              ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: jsonFalse.data.length,
                  itemBuilder: (context, index) {
                    var dado = jsonFalse.data[index];
                    var horario = Horario.fromJson(dado);
                    return CabelereiroAgendadoTile(
                      horario: horario,
                      servico: horario.servicos.first,
                      token: model.token,
                    );
                  }),
            ],
          ),
        );
      });
    });
  }
}
