importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyAMLk1-dj8g0qCqU3DkxLKHbrT0VhK5EeQ",
    authDomain: "e-food-9e6e3.firebaseapp.com",
    projectId: "e-food-9e6e3",
    storageBucket: "e-food-9e6e3.appspot.com",
    messagingSenderId: "410522356318",
    appId: "1:410522356318:web:1f962a90aabeb82a3dc2cf",
    measurementId: "G-X1LHXV0DK1",
    databaseURL: "...",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
});
