import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();
const crypto = require('crypto');
const segredo = 'a2e3f5t9w0c7v34tx321ve05morbtiex';

const db = admin.firestore();
const fcm = admin.messaging();

//Criptografia dos dados
function encrypt(usuario: String) {
  const iv = Buffer.from(crypto.randomBytes(16));
  const cipher = crypto.createCipheriv('aes-256-cbc', Buffer.from(segredo), iv);
  let encrypted = cipher.update(usuario);
  encrypted = Buffer.concat([encrypted, cipher.final()])
  return `${iv.toString('hex')}:${encrypted.toString('hex')} `;
}

function decrypt(usuario: String) {
  const [iv, encrypted] = usuario.split(':');
  const ivBuffer = Buffer.from(iv, 'hex');
  const decipher = crypto.createDecipheriv('aes-256-cbc', Buffer.from(segredo), ivBuffer);
  let content = decipher.update(Buffer.from(encrypted, 'hex'));
  content = Buffer.concat([content, decipher.final()]);
  return content.toString();
}
//////////////////////////////////////////////////////////////


//Funções de exportação do Firebase
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

      //GetCabeleireiro
      const usuario_id = querySnapshot.get('cabeleireiro')
      const queryCabeleireiro = await db
        .collection('usuarios')
        .doc(usuario_id)
        .get()
      const nome = queryCabeleireiro.get('nome')



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

export const quantidadeConfirmados = functions.firestore
  .document('horarios/{horarioID}')
  .onCreate(async snapshot => {
     
      const cabeleireiro = snapshot.get('cabeleireiro')
      
      const queryToken = await db
        .collection('usuarios')
        .doc(cabeleireiro)
        .get()
      const token = queryToken.get('token') 

      const queryCont = await db.collection('horarios')
        .where('confirmado', '==', false)
        .where('cabeleireiro', '==', cabeleireiro)
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

  });
/*export const notificaQuantidadeConfirmados = functions.firestore
  .document('horarios/{horarioID}')
  .onUpdate(async (change, context) => { //mudar pra onCreate
    if (change.before.get('ocupado') != change.after.get('ocupado')) {
      const horario_id = context.params.horarioID
      //Get horarios
      const querySnapshot = await db
        .collection('horarios')
        .doc(horario_id)
        .get();

      const usuario_id = querySnapshot.get('cabeleireiro')
      const queryToken = await db
        .collection('usuarios')
        .doc(usuario_id)
        .get()
      const token = queryToken.get('token')

      const queryCont = await db.collection('horarios')
        .where('confirmado', '==', false)
        .where('cabeleireiro', '==', usuario_id)
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
  });*/

export const enviaEmailConfirmacaoCabeleireiro = functions.firestore
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
      const criptado = encrypt(usuario_id);

      const mailOptions = {
        from: `App hair`,
        to: usuario.get('email'),
        subject: 'Email de confirmação',
        html: `<h1>Parabéns!!</h1>
               <p>
                Agora você é um cabeleireiro do salão ${salao.get('nome')}
               </p><br>
               Clique neste 
               <a href=https://us-central1-agendamento-cortes.cloudfunctions.net/confirmaCabeleireiroEmail?usuario=${criptado}>link</a>
               para confirmar a ação`
      };


      return transporter.sendMail(mailOptions, (error: any) => {
        if (error) {
          console.log(error)
          return
        }
        console.log(`Enviado!`)
      });
    }

  });

export const confirmaCabeleireiroEmail = functions.https
  .onRequest(async (request, response) => {
    const usuario = decrypt(`${request.query.usuario}`);
    if (!usuario) {
      response.status(400).send("ERRO AO ENCONTRAR USUÁRIO")
    }


    await db.collection('usuarios').doc(`${usuario}`).update({ cabeleireiro: true })
    const query = await db
      .collection('usuarios')
      .doc(`${usuario}`)
      .get();
    response.send(`<h1>Olá ${query.get('nome')}!</h1><br><b>Reinicie seu app para utilizar todas as funcionalidades</b>`)
  });