import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();


export const sendToDevice = functions.firestore
  .document('usuarios/{usuarioId}/horarios/{horarioID}')
  .onUpdate(async (change, context) => {

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

    if (change.before.get('confirmado') != change.after.get('confirmado')) {
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