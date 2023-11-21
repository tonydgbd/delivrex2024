importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyAxj5xo8kXiF44MyXNTfGehvf_n08GFnz4",
  authDomain: "efood-web.firebaseapp.com",
  projectId: "efood-web",
  storageBucket: "efood-web.appspot.com",
  messagingSenderId: "709417645771",
  appId: "1:709417645771:web:e6772b8e943f1380ad8d4e",
  databaseURL: "...",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  //console.log("onBackgroundMessage", message);
});