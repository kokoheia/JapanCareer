//importing all of the funcitions required to the project inside of the constant functions
const functions = require('firebase-functions');

// The Firebase Admin SDK to access the Firebase Realtime Database.
const admin = require('firebase-admin');
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
//exports is the global variable that can initialize other properties on.
exports.helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase!");
});

exports.observeApply = functions.database.ref('/user-apply/{companyId}/{studentId}')
.onCreate(event => {
  console.log("Attempting to apply....")
  console.log(event.params);

  var companyId = event.params.companyId;
  var studentId = event.params.studentId;

  console.log('Student ' + studentId + 'is applying to ' + companyId);

})




//listen for messages
exports.observeMessage = functions.database.ref('/user-messages/{uid}/{messagePartnerId}/{messageId}')
.onCreate((snap, context) => {
  // console.log(context.params);

  var uid = context.params.uid;
  var messagePartnerId = context.params.messagePartnerId;

  // console.log('User ' + uid + ' has been sent a message from ' + messagePartnerId);


  //company -> studnet
  return admin.database().ref('/users/student/' + messagePartnerId).once('value', snapshot => {

    var student = snapshot.val();

    return admin.database().ref('/users/company/' + uid).once('value', snapshot => {
      var company = snapshot.val();

      var message = {
        notification: {
          title: 'You got a new message',
          body: company.name + ' has now messaged you.'
        },
        data: {
          score: '850',
          time: '2:45',
          senderId: company
        },
        token: student.fcmToken
      }

      admin.messaging().send(message)
        .then((response) => {
          // Response is a message ID string.
          return console.log('Successfully sent message:', response);
        }).catch((error) => {
          console.log('Error sending message:', error);
        });
    })
  })
  //student -> company
  // return admin.database().ref('/users/company/' + messagePartnerId).once('value', snapshot => {
  //
  //   var company = snapshot.val();
  //
  //   return admin.database().ref('/users/student/' + uid).once('value', snapshot => {
  //     var student = snapshot.val();
  //
  //     var message = {
  //       notification: {
  //         title: 'You got a new message',
  //         body: student.name + ' has now messaged you.'
  //       },
  //       data: {
  //         score: '850',
  //         time: '2:45'
  //       },
  //       token: company.fcmToken
  //     }
  //
  //     admin.messaging().send(message)
  //       .then((response) => {
  //         // Response is a message ID string.
  //         return console.log('Successfully sent message:', response);
  //       }).catch((error) => {
  //         console.log('Error sending message:', error);
  //       });
  //   })
  // })
})

exports.sendPushNotification = functions.https.onRequest((req, res) => {
  res.send("Attempting to send push notification...")

  console.log("LOGGER --- Trying to send push message...")

  // admin.message().sendToDevice(token, payload)
  // This registration token comes from the client FCM SDKs.
    var uid = 'm4NJtooqotgqyWofhBygHs6qLOw1'

    return admin.database().ref('/users/student/'+ uid).once('value', snapshot => {
      console.log(snapshot)
      var user = snapshot.val();


      console.log('User username: ' + user.name + 'fcmToken: ' + user.fcmToken)

      var message = {
        notification: {
          title: "Push notification TITLE HERE",
          body: "Body over here is our message body..."
        },
        data: {
          score: '850',
          time: '2:45'
        },
        token: user.fcmToken
      }

      admin.messaging().send(message)
        .then((response) => {
          // Response is a message ID string.
          return console.log('Successfully sent message:', response);
        })
        .catch((error) => {
          console.log('Error sending message:', error);
        });
    })

  // var fcmToken = 'f12498Pukbc:APA91bFGZVr8vVkE1LyTSEHZ-uFQlaIPyrRtTmHG5NPaqk_8vtTMW9GAR8xyKIexMw_5lgdXt_dOVczIpGMEOAhZFFWxvQYP_32Gp5AInJWUchQnL9SGBRfTX-CmWqKalnf10FUoPFYa';

  // See documentation on defining a message payload.
  // var message = {
    // notification: {
    //   title: "Push notification TITLE HERE",
    //   body: "Body over here is our message body..."
    // },
    // data: {
    //   score: '850',
    //   time: '2:45'
    // },
    // token: fcmToken
  // };
  //
  // // Send a message to the device corresponding to the provided
  // // registration token.

})
