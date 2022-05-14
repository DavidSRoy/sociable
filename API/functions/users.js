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
 * createUser
 * request:
 * uid: user's UID
 * firstName: [required]
 * lastName: 
 * email:
 * dob: date of birth [required]
 */
users_api.post('/createUser', async (request, response) => {
  const req_key = request.get('auth');
  if (req_key == KEY) {
    const uid = request.query.uid;
    const firstName = request.query.firstName;
    const lastName = request.query.lastName;
    const email = request.query.lastName;
    const dob = request.query.dob


    admin.auth()
    .createUser({
      email: 'user@example.com',
      emailVerified: false,
      phoneNumber: '+11234567890',
      password: 'secretPassword',
      displayName: 'John Doe',
      photoURL: 'http://www.example.com/12345678/photo.png',
      disabled: false,
    })
    .then((userRecord) => {
      // See the UserRecord reference doc for the contents of userRecord.
      console.log('Successfully created new user:', userRecord.uid);
    })
    .catch((error) => {
      console.log('Error creating new user:', error);
    });

  } else {
    response.status(401).send('Unauthorized');
  }
});




exports.users_api = functions.https.onRequest(users_api)