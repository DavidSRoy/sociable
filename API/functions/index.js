const admin = require('firebase-admin');
const FieldValue = require('firebase-admin').firestore.FieldValue;
const Timestamp = require('firebase-admin').firestore.Timestamp;
const functions = require('firebase-functions');
const express = require('express');
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

admin.initializeApp();
const firestore = admin.firestore();


const PROJECTID = 'sociable-messenger';
const USERS = firestore.collection('test_users');
const KEY = functions.config().messaging.key;

const messaging_api = express();


async function getUsers() {
    const snapshot = await USERS.get();
    return snapshot.docs.map(doc => doc.data());
    //.map(doc => doc.id);
  }

messaging_api.get('/getUsers', async (request, response) => {
  const req_key = request.get('auth');
  if (req_key == KEY) {
    await response.json(await getUsers());
  } else {
    response.status(401).send('Unauthorized');
  }
});

messaging_api.post('/send', async (request, response) => {
  
  const req_key = request.get('auth');
  if (req_key == KEY) {
    // response.status(200).send('OK');
    const uid = request.query.uid;
    const msg = request.query.msg;
    const senderUid = request.query.sender;

    const ref = USERS.doc(uid)
    console.log("UID = " + uid);
    console.log('msg = ' + msg)
    console.log('senderUid = ' + senderUid);

    await ref.update({
      msgs: FieldValue.arrayUnion({
        msg: msg,
        sender: senderUid,
        timestamp: Timestamp.now()
      })
    })
    .then(() => {
        console.log("Document successfully written!");
        response.status(200).send('OK')
    });

  } else {
    response.status(401).send('Unauthorized');
  }
  response.json({"req" : request.query.test});
});

messaging_api.get('/test', async (request, response) => {
  response.json({"test2":"message"});
});

//check for new messages of uid
messaging_api.get('/getMessages', async (request, response) => {
  const req_key = request.get('auth');
  if (req_key == KEY) {
    await response.json(await getMessages(request.query.uid));
  } else {
    response.status(401).send('Unauthorized');
  }
});

async function getMessages(uid) {
  const snapshot = await firestore.collection('test_users').doc(uid).get(); 
  return snapshot.data();
}

exports.messaging_api = functions.https.onRequest(messaging_api)