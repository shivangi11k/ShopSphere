const admin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://shopsphere-18cea-default-rtdb.asia-southeast1.firebasedatabase.app"
});

const db = admin.database(); // or use admin.firestore() if you chose Firestore

module.exports = { db, admin };
