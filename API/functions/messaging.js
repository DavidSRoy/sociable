const admin = require('firebase-admin');
const FieldValue = require('firebase-admin').firestore.FieldValue;
const Timestamp = require('firebase-admin').firestore.Timestamp;
const functions = require('firebase-functions');
const serviceAccount = require('/Users/athomas/Downloads/sociable/API/secrets/serviceAccount.json');
const gc = require('@google-cloud/storage');
//const fStorage = require('@firebase/storage'); 
const express = require('express');
const {v4: uuid} = require('uuid');
//var gcloud = require('google-cloud');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

admin.initializeApp({storageBucket: "sociable-messenger.appspot.com",
credential: admin.credential.cert(serviceAccount)
});
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
  const snapshot = await USERS.doc(uid).get(); 
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
      const ref = STATUS

      ref.doc(uid).set({
        image: metadata.metadata.firebaseStorageDownloadTokens,
        fileName: filename,
        uid: uid
      });
    }
  }); 


  // // Uploads a local file to the bucket
  // await bucket.upload(String(filePath), {
  //   // Support for HTTP requests made with `Accept-Encoding: gzip`
  //   gzip: true,
  //   metadata: metadata,
  // });

  // // get the fullpath
  // const filename = filePath.split('/').pop();
  // console.log(filename);

  // bucket.getFiles(function(err, files) {
  //   if (!err) {
  //     // files is an array of File objects.
  //     console.log("length: " + files.length);
  //     files.forEach(function(entry) {
  //       console.log(entry);
  //     });
  //   }
  // });

  // Lists files in the bucket
  // const getFilesOptions = {
  //   directory: "images/",
  // } 

  // const [files] = await bucket.getFiles(getFilesOptions);

  // console.log('Files:');
  // files.forEach(file => {
  //   console.log(file.name);
  // });
  //const imageRef = bucket.file("codingclub"); 
  
  // imageRef.exists(function(err, exists) {});
  // // If the callback is omitted, then this function return a Promise.
  // imageRef.exists().then(function(data) {
  //   var exists = data[0];
  // });
  // console.log("file exists: " + exists);


  
  // Get metadata properties
  //imageRef.getMetadata(function(err, imageMetadata, apiResponse) {});

  //-
  // If the callback is omitted, we'll return a Promise.
  //-
  // imageRef.getMetadata().then(function(data) {
  //   const imageMetadata = data[0];
  //   const apiResponse = data[1];
  // });

  console.log(`${filePath} uploaded.`);
}

uploadImage().catch(console.error);


//retrieve status-- image format
messaging_api.get('/getImage', async (request, response) => {
  const req_key = request.get('auth');
  if (req_key == KEY) {
    const fileName = request.query.filename;
    await response.json(await getImage(fileName));
    console.log("File successfully retrieved!");
  } else {
    response.status(401).send('Unauthorized');
  }
});

// get the image download url from storage
// valid for 1 hour
async function getImage(fileName) {
  console.log(fileName);
 
  const options = {
    version: 'v2', // defaults to 'v2' if missing.
    action: 'read',
    expires: Date.now() + 1000 * 60 * 60, // one hour
  };

  // Get a v2 signed URL for the file
  const file = bucket.file(fileName);
  const url = file.getSignedUrl(options);

  return url;
};

getImage().catch(console.error);


//check for new statuses of uid
messaging_api.get('/getStatuses', async (request, response) => {
  const req_key = request.get('auth');
  if (req_key == KEY) {
    await response.json(await getStatuses(request.query.uid));
  } else {
    response.status(401).send('Unauthorized');
  }
});

async function getStatuses(uid) {
  const snapshot =  await STATUS.doc(uid).get();
  return snapshot.data();
}

exports.messaging_api = functions.https.onRequest(messaging_api)