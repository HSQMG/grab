import { collection,  where, query, getDocs} from "https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore.js";
import { db } from "../../js/firebase.js";

const rideRef = collection(db, "rides");
const q = query(rideRef, where("status", "==", "completed"));


export async function getRevenue() {
    var data = [0, 0, 0, 0, 0, 0]
    // Create the table header
    const querySnapshot = await getDocs(q);
    querySnapshot.forEach((doc) => {
        const ride = doc.data();
        const date = ride.endTime.toDate();
        if(date.getMonth() <= 5) 
            data[date.getMonth()] += ride.fare;
    });
    console.log(data)
    return data;
  
}