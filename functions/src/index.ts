import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();
const db = admin.firestore();
const fcm = admin.messaging();

//Criptografia dos dados
const crypto = require('crypto');
const criptografia = 'aes-256-cbc';
const segredo = 'd07e0fc6981b4f9041cf35030e05d286';
const tipo = 'hex';

async function encrypt(usuario: String) {
  const iv = Buffer.from(crypto.randomBytes(16));
  let cipher = crypto.createCipheriv(criptografia, Buffer.from(segredo), iv);
  let encrypted = cipher.update(usuario)
  encrypted = Buffer.concat([encrypted, cipher.final()])
  return `${encrypted.toString(tipo)}:${iv.toString(tipo)}`;
}

async function decrypt(usuario: String) {
  const [id, iv] = usuario.split(':')
  const ivBuffer = Buffer.from(iv, tipo);
  let decipher = crypto.createDecipheriv(criptografia, Buffer.from(segredo), ivBuffer)
  const idReal = Buffer.concat([decipher.update(Buffer.from(id, tipo)), decipher.final()]);
  return idReal.toString()
}
//////////////////////////////////////////////////////////////

function distancia(lat1: number, lon1: number, lat2: number, lon2: number) {
  const haversine = require('haversine');
  const start = {
    latitude: lat1,
    longitude: lon1
  }

  const end = {
    latitude: lat2,
    longitude: lon2
  }
  return haversine(start, end, { unit: 'meter' }) / 1000

}


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
        },
        data: {
          screen: "marcado_tela"
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
      .get()

    const cont = queryCont.docs.length
    if (cont > 0) {
      const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: `Há um novo agendamento esperando para ser confirmado`,
          body: `Confirme os ${cont} agendamentos assim que possível`,
          click_action: 'FLUTTER_NOTIFICATION_CLICK',
        },
        data: {
          screen: "confirmar_tela"
        }

      };
      return fcm.sendToDevice(token, payload);
    }
    return null;
  });

export const enviaEmailConfirmacaoCabeleireiro = functions.firestore
  .document('usuarios/{usuarioID}')
  .onUpdate(async (change, context) => {
    const usuario_id = context.params.usuarioID;

    if (change.before.get('salaoTemp') != change.after.get('salaoTemp') && change.after.get('salaoTemp') != null) {
      const usuario = await db
        .collection('usuarios')
        .doc(usuario_id)
        .get();

      const salao = await db
        .collection('saloes')
        .doc(change.after.get('salaoTemp'))
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
      const criptado = await (encrypt(usuario_id));

      const mailOptions = {
        from: `App hair`,
        to: usuario.get('email'),
        subject: 'Email de confirmação',
        html: `<h1>Olá ${usuario.get('nome')}!</h1>
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
    const usuarioId = await decrypt(`${request.query.usuario}`);
    console.log(usuarioId);
    if (!usuarioId) {
      response.status(400).send("ERRO AO ENCONTRAR USUÁRIO")
    }
    const usuario = await db.collection('usuarios').doc(`${usuarioId}`).get()
    const salaoTemp = usuario.get('salaoTemp')
    await db.collection('usuarios').doc(`${usuarioId}`)
      .update({
        salao: salaoTemp,
        cabeleireiro: true,
        salaoTemp: admin.firestore.FieldValue.delete()
      });

    return response.status(200).send(`<h1>Olá ${usuario.get('nome')}!</h1><br><b>Reinicie seu app para utilizar todas as funcionalidades</b>`)
  });

export const horarioCancelado = functions.firestore
  .document('horarios/{horarioID}')
  .onDelete(async (event) => {

    const queryCliente = await db
      .collection('usuarios')
      .doc(event.get('cliente'))
      .get()

    const queryCabeleireiro = await db
      .collection('usuarios')
      .doc(event.get('cabeleireiro'))
      .get()

    const token = queryCliente.get('token')
    const cabeleireiro = queryCabeleireiro.get('nome')

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: `Seu agendamento foi cancelado pelo cabeleireiro`,
        body: `Seu horário com ${cabeleireiro} foi cancelado`,
        click_action: 'FLUTTER_NOTIFICATION_CLICK',
      }
    };
    return fcm.sendToDevice(token, payload);
  });

/*async function getResumoSalao(id: string) {
  return await db
    .collection('saloes')
    .doc(id)
    .collection('resumo')
    .doc('resumo')
    .get().then((doc) => { return { teste: doc.get('menorValorServico') } }).catch((e) => { return e })

}*/

export const calculaDistancia = functions.https
  .onRequest(async (request, response) => {
    const cidade = request.query.cidade;
    const lat = request.query.lat as string;
    const lng = request.query.lng as string;


    if (!cidade || lat == '' || lng == '') {
      response.status(400).send('Erro ao enviar atributos');
    }
    const saloes = await db
      .collection('saloes')
      .where('cidade', '==', cidade)
      .orderBy('nome')
      .get()

    let json = saloes.docs.map((doc) => {
      return {
        id: doc.id,
        data: doc.data(),
        distancia: distancia(doc.get('latitude'), doc.get('longitude'), parseFloat(lat), parseFloat(lng)),
      };
    });

    json.sort((a, b) => {
      return a.distancia - b.distancia;
    })
    if (json.length == 0) {
      response.status(404).send("Não há salões para sua cidade ainda\nEntre em contato conosco e sugira um salão ;)")
    }
    response.status(200).json(json)
  });

export const calculaValoresResumo = functions.firestore
  .document('servicos/{servicoID}')
  .onCreate(async snapshot => {
    const resumo = await db
      .collection('saloes')
      .doc(snapshot.get('salao'))
      .collection('resumo')
      .doc('resumo')
      .get()
    if (resumo.data.length > 0) {
      let mudou = false;
      let menor = resumo.get('menorValorServico');
      let maior = resumo.get('maiorValorServico');
      if (snapshot.get('valor') < menor) {
        menor = snapshot.get('valor')
        mudou = true;
      }
      if (snapshot.get('valor') > maior) {
        maior = snapshot.get('valor')
        mudou = true;
      }
      if (mudou)
        await db
          .collection('saloes')
          .doc(snapshot.get('salao'))
          .collection('resumo')
          .doc('resumo')
          .update({
            'menorValorServico': menor,
            'maiorValorServico': maior
          });
    }
  });

export const calculaAvaliacaoResumo = functions.firestore
  .document('avaliacoes/{avaliacaoID}')
  .onCreate(async snapshot => {
    const resumo = await db
      .collection('saloes')
      .doc(snapshot.get('salao'))
      .collection('resumo')
      .doc('resumo')
      .get()
    if (resumo.data.length > 0) {

      const total = resumo.get('mediaAvaliacao') + snapshot.get('avaliacao');
      await db
        .collection('saloes')
        .doc(snapshot.get('salao'))
        .collection('resumo')
        .doc('resumo')
        .update({
          'quantidadeAvaliacao': admin.firestore.FieldValue.increment,
          'totalAvaliacao': total
        });
    }
  });