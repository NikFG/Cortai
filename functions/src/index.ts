import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();


export const notificaConfirmado = functions.firestore
  .document('usuarios/{usuarioId}/horarios/{horarioID}')
  .onUpdate(async (change, context) => {
    if (change.before.get('confirmado') != change.after.get('confirmado')) {
      const usuario_id = context.params.usuarioId
      const horario_id = context.params.horarioID


      //Get horario
      const querySnapshot = await db
        .collection('usuarios')
        .doc(usuario_id)
        .collection('horarios')
        .doc(horario_id)
        .get();

      //GetClientes
      const cliente = querySnapshot.get('cliente')
      const queryCliente = await db
        .collection('usuarios')
        .doc(cliente)
        .get()
      const token = queryCliente.get('token')

      //GetCabelereiro
      const queryCabelereiro = await db
        .collection('usuarios')
        .doc(usuario_id)
        .get()
      const nome = queryCabelereiro.get('nome')
      // let horario = querySnapshot.get('horario');
      //horario = Date.parse(horario);


      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: `Seu agendamento foi confirmado!!!! `,
          body: `${nome} confirmou seu agendamento`,
          click_action: 'FLUTTER_NOTIFICATION_CLICK'
        }
      };

      return fcm.sendToDevice(token, payload);
    } else {
      return null;
    }
  });

export const notificaQuantidadeConfirmados = functions.firestore
  .document('usuarios/{usuarioId}/horarios/{horarioID}')
  .onUpdate(async (change, context) => {
    if (change.before.get('confirmado') != change.after.get('confirmado')) {
      const usuario_id = context.params.usuarioId



      //Get horarios
      const querySnapshot = await db
        .collection('usuarios')
        .doc(usuario_id)
        .collection('horarios')
        .where('confirmado', '==', false)
        .get();

      const cont = querySnapshot.docs.length; // quantidade a ser confirmada
      if (cont > 4) {
        const queryToken = await db
          .collection('usuarios')
          .doc(usuario_id)
          .get()
        const token = queryToken.get('token')

        const payload: admin.messaging.MessagingPayload = {
          notification: {
            title: `Confirme os agendamentos assim que possível `,
            body: `Há ${cont} agendamentos esperando para serem confirmados`,
            click_action: 'FLUTTER_NOTIFICATION_CLICK'
          }
        };

        return fcm.sendToDevice(token, payload);
      }
    }
    return null;
  });