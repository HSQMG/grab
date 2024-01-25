import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
import { getAnalytics } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-analytics.js";
import { getAuth } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-auth.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore.js";

const firebaseConfig = {
    apiKey: "AIzaSyCP_3-ki0ApMEMoxeTnJ3yv-2cpFC7aVtk",
    authDomain: "grab-intro2sw-96bbf.firebaseapp.com",
    databaseURL: "https://grab-intro2sw-96bbf-default-rtdb.firebaseio.com",
    projectId: "grab-intro2sw-96bbf",
    storageBucket: "grab-intro2sw-96bbf.appspot.com",
    messagingSenderId: "982285894910",
    appId: "1:982285894910:web:b2b457008387beab1351af",
    measurementId: "G-2ZKGL1EWPE"
};

      

// Initialize Firebase
export const app = initializeApp(firebaseConfig);
export const analytics = getAnalytics(app);
export const auth = getAuth();
export const db = getFirestore(app);