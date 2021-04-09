import 'package:cortai/Controle/horario_controle.dart';
import 'package:cortai/Modelos/login_modelo.dart';
import 'package:cortai/Stores/calendario_store.dart';
import 'package:cortai/Tiles/calendario_tile.dart';
import 'package:cortai/Widgets/shimmer_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sizer/sizer.dart';

class CalendarioTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CalendarioStore store = CalendarioStore();
    return ScopedModelDescendant<LoginModelo>(builder: (context, child, model) {
      store.filtraData(HorarioControle.getCalendario(), model.token);
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
        body: Observer(
          builder: (context) {
            if (store.isLoading) {
              return ShimmerCustom(4);
            } else {
              return ListView(
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
                  store.isHojeEmpty
                      ? Text("Não há horários hoje")
                      :
                      //ListView que carrega as Tiles de HOJE
                      ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: store.horariosHoje.length,
                          itemBuilder: (context, index) {
                            var horario = store.horariosHoje[index];
                            return CalendarioTile(
                              horario: horario,
                              servico: horario.servicos.first,
                              token: model.token,
                            );
                          }),
                  Container(
                    padding: EdgeInsets.all(2.0.h),
                    child: Text(
                      "Próximos sete dias",
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
                  store.isSeteEmpty
                      ? Text("Não há horários para os próximos sete dias")
                      :
                      //ListView que carrega as Tiles dessa SEMANA
                      ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: store.horariosSete.length,
                          itemBuilder: (context, index) {
                            var horario = store.horariosSete[index];
                            return CalendarioTile(
                              horario: horario,
                              servico: horario.servicos.first,
                              token: model.token,
                            );
                          }),
                  Container(
                    padding: EdgeInsets.all(2.0.h),
                    child: Text(
                      "Futuro",
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
                  store.isMesEmpty
                      ? Text("Não há horários futuros")
                      :
                      //ListView que carrega as Tiles desse MÊS
                      ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: store.horariosMes.length,
                          itemBuilder: (context, index) {
                            var horario = store.horariosMes[index];
                            return CalendarioTile(
                              horario: horario,
                              servico: horario.servicos.first,
                              token: model.token,
                            );
                          }),
                ],
              );
            }
          },
        ),
      );
    });
  }
}
