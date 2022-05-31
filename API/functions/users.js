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
 * uid: current user uid
 */
users_api.get('/getUserInfo', async (request, response) => {
  const req_key = request.get('auth');

  const uid = request.query.uid;

  if (req_key == KEY) {
    const doc = await USERS.doc(uid).get();
    if (doc.exists) {
      return response.json({
        displayName: doc.data().displayName,
        bio: doc.data().bio,
        friends: doc.data().friends,
        profilePic: doc.data().profilePic

      });
    }  else {
      return response.json({});
    }
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
 * uid: current user uid
 * friendUid: uid of friend to be added
 */
users_api.post('/addFriend', async (request, response) => {
  const req_key = request.get('auth');
  if (req_key == KEY) {
    const uid = request.query.uid;
    const friendUid = request.query.friendUid;

    USERS.doc(uid).update({
      friends: FieldValue.arrayUnion(friendUid)
    })
    .then((userRecord) => {
      response.status(200).send("OK");
    }).catch((error) => {
      console.log('Error adding friend:', error);
      response.status(500).send("Internal Server Error");
    });

  } else {
    response.status(401).send('Unauthorized');
  }
});

/**
 * uid: current user uid
 */
users_api.get('/getFriends', async (request, response) => {
  const req_key = request.get('auth');
  if (req_key == KEY) {
    const uid = request.query.uid;
    const doc = await USERS.doc(uid).get();
    if (doc.exists) {
      return await response.json(doc.data().friends);
    } else {
      return response.json({});
    }

  } else {
    response.status(401).send('Unauthorized');
  }
});


/**
 * uid: current user uid
 * friendUid: uid of friend to be removed
 */
users_api.post('/removeFriend', async (request, response) => {
  const req_key = request.get('auth');
  if (req_key == KEY) {
    const uid = request.query.uid;
    const friendUid = request.query.friendUid;

    USERS.doc(uid).update({
      friends: FieldValue.arrayRemove(friendUid)
    })
    .then((userRecord) => {
      response.status(200).send("OK");
    }).catch((error) => {
      console.log('Error removing friend:', error);
      response.status(500).send("Internal Server Error");
    });

  } else {
    response.status(401).send('Unauthorized');
  }
});

/**
 * uid: current user uid
 * displayName: new display name
 */
users_api.post('/setDisplayName', async (request, response) => {
  const req_key = request.get('auth');
  if (req_key == KEY) {
    const uid = request.query.uid;
    const displayName = request.query.displayName;
    USERS.doc(uid).update({
      displayName: displayName
    })
    .then((userRecord) => {
      response.status(200).send("OK");
    }).catch((error) => {
      console.log('Error setting display name:', error);
      response.status(500).send("Internal Server Error");
    });

  } else {
    response.status(401).send('Unauthorized');
  }
});


/**
 * uid: current user uid
 * bio: new bio
 */
users_api.post('/setBio', async (request, response) => {
  const req_key = request.get('auth');
  if (req_key == KEY) {
    const uid = request.query.uid;
    const bio = request.query.bio;

    USERS.doc(uid).update({
      bio: bio
    })
    .then((userRecord) => {
      response.status(200).send("OK");
    }).catch((error) => {
      console.log('Error setting new bio:', error);
      response.status(500).send("Internal Server Error");
    });

  } else {
    response.status(401).send('Unauthorized');
  }
});

/**
 * uid: current user uid
 * filePath: filePath of profile photo
 */
users_api.post('/setProfilePhoto', async (request, response) => {
  const req_key = request.get('auth');
  if (req_key == KEY) {
    const uid = request.query.uid;
    const filePath = request.query.filePath;
    await uploadImage(filePath, uid);
    console.log("File successfully uploaded!");
    response.status(200).send('OK') 
  } else {
    response.status(401).send('Unauthorized');
  }
  //response.json({"req" : request.query.test});
});

async function uploadImage(filePath, uid) {
  try {
    console.log(filePath);
    // get the name
    const filename = filePath.split('/').pop();
    console.log(filename);

    const metadata = {
      metadata: {
        // create a download token
        firebaseStorageDownloadTokens: uuid()
      },
      contentType: 'image/png',
      cacheControl: 'public, max-age=31536000',
    }; 

    const options = {
      destination: filename,
      metadata: metadata
    };
    
    //const storagePath = "";

    bucket.upload(String(filePath), options, function(err, file) {
      // Your bucket now contains:
      // - "new-image.png" (with the contents of `local-image.png')
    
      if (!err) {
        //updateFilePath(file.fullPath);
        // update firestore
        const ref = USERS

        ref.doc(uid).update({
          profilePic: {
            reference: metadata.metadata.firebaseStorageDownloadTokens,
            fileName: filename
          } 
        });
      }
    }); 

    console.log(`${filePath} uploaded.`);
  } catch (e) {
    console.log(e);
  }
}

//validates user exists 
messaging_api.get('/userExist', async (request, response) => {
  const req_key = request.get('auth');
  if (req_key == KEY) {
     USERS.where('firstName', '==', request.query.name)
    .get()
    .then(function(querySnapshot) {
        querySnapshot.forEach(function(doc) {
            return doc.id;
        });
    })
    .catch(function(error) {
        console.log("Error getting documents: ", error);
    });
  } else {
    response.status(401).send('Unauthorized');
  } 
});


exports.users_api = functions.https.onRequest(users_api)
