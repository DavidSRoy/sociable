//import { getStorage, ref, uploadBytes } from "firebase/storage";

const admin = require('firebase-admin');
const FieldValue = require('firebase-admin').firestore.FieldValue;
const Timestamp = require('firebase-admin').firestore.Timestamp;
const functions = require('firebase-functions');
const express = require('express');
const {v4: uuid} = require('uuid');



// Get a reference to the storage service, which is used to create references in storage bucket
const storage = admin.storage();
// Create a storage reference from our storage service
const bucket = storage.bucket();

const firestore = admin.firestore();

const PROJECTID = 'sociable-messenger';
const USERS = firestore.collection('test_users');
const KEY = functions.config().messaging.key;
const users_api = express();


async function getUsers() {
    const snapshot = await USERS.get();
    return snapshot.docs.map(doc => doc.data());
  }

users_api.get('/getUsers', async (request, response) => {
  const req_key = request.get('auth');
  if (req_key == KEY) {
    await response.json(await getUsers());
  } else {
    response.status(401).send('Unauthorized');
  }
});

/**
 * createUser params
 * 
 * displayName: [required]
 * password: [required]
 * email:
 * phone:
 * dob: date of birth [required]
 */
users_api.post('/createUser', async (request, response) => {
  const req_key = request.get('auth');
  if (req_key == KEY) {
    const displayName = request.query.displayName;
    const password = request.query.password;
    const email = request.query.email;
    const phone = request.query.phone;
    const dob = request.query.dob;

    console.log(displayName);
    console.log(password);
    console.log(email);
    console.log(phone);
    console.log(dob);

    admin.auth()
    .createUser({
      email: email,
      emailVerified: false,
      password: password,
      displayName: displayName,
      photoURL: 'http://www.example.com/12345678/photo.png',
      disabled: false,
    })
    .then((userRecord) => {
      // See the UserRecord reference doc for the contents of userRecord.
      console.log('Successfully created new user:', userRecord.uid);
      USERS.doc(userRecord.uid).set({
        displayName: displayName,
        password: password,
        dob: dob
      });
      response.status(200).send("OK");
    })
    .catch((error) => {
      console.log('Error creating new user:', error);
      response.status(500).send("Internal Server Error");
    });


  } else {
    response.status(401).send('Unauthorized');
  }
});


/**
 * password: [required]
 * email:
 */
users_api.post('/login', async (request, response) => {
  const req_key = request.get('auth');
  if (req_key == KEY) {

    const password = request.query.password;
    const email = request.query.email;

    let user;
    admin.auth().getUserByEmail(email)
    .then((userRecord) => {
      // See the UserRecord reference doc for the contents of userRecord.
      console.log('Successfully received in user info:', userRecord.uid);
      console.log(userRecord);

      if (true) {
        response.status(200).send("OK");
      } else {
        response.status(403).send("Forbidden");
      } 
    })
    .catch((error) => {
      console.log('Error logging in user:', error);
      response.status(500).send("Internal Server Error");
    });

  } else {
    response.status(401).send('Unauthorized');
  }

});

/**
 * password: [required]
 * email:
 */
users_api.post('/addFriend', async (request, response) => {

});





exports.users_api = functions.https.onRequest(users_api)
