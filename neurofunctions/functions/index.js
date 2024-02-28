/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNotification = functions.https.onCall(async (data, context) => {
  const notification = {
    title: data.title,
    body: data.body,
  };

  if (data.imageUrl && data.imageUrl !== "nothing") {
    notification.imageUrl = data.imageUrl;
  }

  await admin.messaging().sendMulticast({
    tokens: data.tokens,
    notification: notification,
    android: {
      priority: "high",
      notification: {
        click_action: "FLUTTER_NOTIFICATION_CLICK",
      },
    },
    data: {
      screen: data.screen,
      dataId: data.dataId,
    },
  });
});


// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
