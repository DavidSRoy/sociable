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


const firestore = admin.firestore();

const PROJECTID = 'sociable-messenger';
const USERS = firestore.collection('test_users');

const messaging_api = express();


async function getUsers() {
    const snapshot = await USERS.get();
    return snapshot.docs.map(doc => doc.data());
    //.map(doc => doc.id);
  }

messaging_api.get('/test', async (request, response) => {
    response.json(await getUsers());
});


<<<<<<< Updated upstream
=======
//check for new messages of uid
messaging_api.get('/getMessages', async (request, response) => {
  const req_key = request.get('auth');
  if (req_key == KEY) {
    await response.json(await getMessages());
  } else {
    response.status(401).send('Unauthorized');
  }
});
>>>>>>> Stashed changes

async function getMessages() {
  const snapshot = await firestore.collection('test_users').doc(getUid()).get(); 
  return snapshot.data().map;
}

exports.messaging_api = functions.https.onRequest(messaging_api)