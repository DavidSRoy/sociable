const admin = require('firebase-admin');
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

messaging_api.post('/send', (request, response) => {
  
  const req_key = request.get('auth');
  if (req_key == KEY) {
    response.status(200).send('OK');
    // const uID = request.query.uid;
    // USERS.doc('')
    // await USERS.update({
    //   msgs: 'test'
    // })
    // .then(() => {
    //     console.log("Document successfully written!");
    // });
  } else {
    response.status(401).send('Unauthorized');
  }
  response.json({"req" : request.query.test});
});


//check for new messages
/*
UID
check uid (new msgs)
*/



exports.messaging_api = functions.https.onRequest(messaging_api)