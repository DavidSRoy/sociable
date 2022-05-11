//import { getStorage, ref, uploadBytes } from "firebase/storage";

const admin = require('firebase-admin');
const FieldValue = require('firebase-admin').firestore.FieldValue;
const Timestamp = require('firebase-admin').firestore.Timestamp;
const functions = require('firebase-functions');
const express = require('express');
const {v4: uuid} = require('uuid');
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


admin.initializeApp({storageBucket: "gs://sociable-messenger.appspot.com"});
// Get a reference to the storage service, which is used to create references in storage bucket
const storage = admin.storage();
// Create a storage reference from our storage service
const bucket = storage.bucket();

const firestore = admin.firestore();

const PROJECTID = 'sociable-messenger';
const USERS = firestore.collection('test_users');
const STATUS = firestore.collection('status');
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

messaging_api.post('/sendMessage', async (request, response) => {
  
  const req_key = request.get('auth');
  if (req_key == KEY) {
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
  console.log(uid);
  const snapshot = await firestore.collection('test_users').doc(uid).get(); 
  return snapshot.data();
}

//delete messages
messaging_api.get('/deleteMessages', async (request, response) => {
  const req_key = request.get('auth');
  if (req_key == KEY) {
    await response.json(await deleteMessages(request.query.uid));
  } else {
    response.status(401).send('Unauthorized');
  }
});

async function deleteMessages(uid) {
  const snapshot = await USERS.doc(uid).update({
    "msgs": admin.firestore.FieldValue.delete()})
  
  return snapshot;

}

async function getMessages(uid) {
  const snapshot = await firestore.collection('test_users').doc(uid).get(); 
  return snapshot.data();
}

//post status-- image format
messaging_api.post('/uploadImage', async (request, response) => {
  const req_key = request.get('auth');
  if (req_key == KEY) {
    const uid = request.query.uid;
    const filePath = request.query.filePath;
    await response.json(await uploadImage(filePath, uid));
    console.log("File successfully uploaded!");
    response.status(200).send('OK') 
  } else {
    response.status(401).send('Unauthorized');
  }
  //response.json({"req" : request.query.test});
});

async function uploadImage(filePath, uid) {
  console.log(filePath);
  const metadata = {
    metadata: {
      // create a download token
      firebaseStorageDownloadTokens: uuid()
    },
    contentType: 'image/png',
    cacheControl: 'public, max-age=31536000',
  }; 

  // Uploads a local file to the bucket
  await bucket.upload(String(filePath), {
    // Support for HTTP requests made with `Accept-Encoding: gzip`
    gzip: true,
    metadata: metadata,
  });

  // update firestore
  const ref = STATUS

  await ref.doc(uid).set({
    image: metadata.metadata.firebaseStorageDownloadTokens
  })

  console.log(`${filePath} uploaded.`);
}

uploadImage().catch(console.error);


exports.messaging_api = functions.https.onRequest(messaging_api)