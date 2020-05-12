import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();




const db = admin.firestore();
const fcm = admin.messaging();


export const notificaConfirmado = functions.firestore
  .document('horarios/{horarioID}')
  .onUpdate(async (change, context) => {
    if (change.before.get('confirmado') != change.after.get('confirmado')) {
      const horario_id = context.params.horarioID


      //Get horario
      const querySnapshot = await db
        .collection('horarios')
        .doc(horario_id)
        .get();
      const horario = querySnapshot.get('horario')
      const data = querySnapshot.get('data')

      //GetClientes
      const cliente = querySnapshot.get('cliente')
      const queryCliente = await db
        .collection('usuarios')
        .doc(cliente)
        .get()
      const token = queryCliente.get('token')

      //GetCabelereiro
      const usuario_id = querySnapshot.get('cabelereiro')
      const queryCabelereiro = await db
        .collection('usuarios')
        .doc(usuario_id)
        .get()
      const nome = queryCabelereiro.get('nome')



      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: `Seu agendamento foi confirmado!!!! `,
          body: `${nome} confirmou seu agendamento no dia ${data} às ${horario}`,
          click_action: 'FLUTTER_NOTIFICATION_CLICK'
        }
      };

      return fcm.sendToDevice(token, payload);
    } else {
      return null;
    }
  });

export const notificaQuantidadeConfirmados = functions.firestore
  .document('horarios/{horarioID}')
  .onUpdate(async (change, context) => {
    if (change.before.get('confirmado') != change.after.get('confirmado')) {
      const horario_id = context.params.horarioID
      //Get horarios
      const querySnapshot = await db
        .collection('horarios')
        .doc(horario_id)
        .get();

      const usuario_id = querySnapshot.get('cabelereiro')
      const queryToken = await db
        .collection('usuarios')
        .doc(usuario_id)
        .get()
      const token = queryToken.get('token')

      const queryCont = await db.collection('horarios')
        .where('confirmado', '==', false)
        .where('cabelereiro', '==', usuario_id)
        .where('ocupado', '==', true)
        .get()

      const cont = queryCont.docs.length

      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: `Há um novo agendamento esperando para ser confirmado`,
          body: `Confirme os ${cont} agendamentos assim que possível`,
          click_action: 'FLUTTER_NOTIFICATION_CLICK',
        }
      };

      return fcm.sendToDevice(token, payload);
    }
    else {
      return null
    }
  });

export const enviaEmailConfirmacaoCabelereiro = functions.firestore
  .document('usuarios/{usuarioID}')
  .onUpdate(async (change, context) => {
    const usuario_id = context.params.usuarioID;

    if (change.before.get('salao') != change.after.get('salao')) {
      const usuario = await db
        .collection('usuarios')
        .doc(usuario_id)
        .get();

      const salao = await db
        .collection('saloes')
        .doc(usuario.get('salao'))
        .get();

      const nodemailer = require('nodemailer');
      const transporter = nodemailer.createTransport({
        host: 'smtp.gmail.com',
        port: 465,
        secure: true,
        auth: {
          user: 'apphair499@gmail.com',
          pass: 'niks1111'
        }
      });


      const mailOptions = {
        from: `App hair`,
        to: usuario.get('email'),
        subject: 'Email de confirmação',
        html: `<h1>Parabéns!!</h1>
               <p>
                Agora você é um cabelereiro do salão ${salao.get('nome')}
               </p><br>
               Clique neste <a href=https://us-central1-agendamento-cortes.cloudfunctions.net/confirmaCabelereiroEmail?usuario=${usuario_id}>link</a> para confirmar a ação 
                        `
      };


      return transporter.sendMail(mailOptions, (error: any, data: any) => {
        if (error) {
          console.log(error)
          return
        }
        console.log(`Enviado!`)
      });
    }

  });

export const confirmaCabelereiroEmail = functions.https
  .onRequest(async (request, response) => {
    const usuario = request.query.usuario;
    if (!usuario) {
      response.status(400).send("ERRO AO ENCONTRAR USUÁRIO")
    }


    await db.collection('usuarios').doc(`${usuario}`).update({ cabelereiro: true })
    const query = await db
      .collection('usuarios')
      .doc(`${usuario}`)
      .get();
    response.send(`<h1>Olá ${query.get('nome')}!</h1><br><b>Reinicie seu app para utilizar todas as funcionalidades</b>`)
  });


