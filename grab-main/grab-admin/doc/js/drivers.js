import { collection, onSnapshot, doc, where, query, updateDoc, getDocs } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-firestore.js";
import { db } from "../../js/firebase.js";

const driverRef = collection(db, "drivers");
const q = query(driverRef, where("isDeleted", "==", false));

export async function deleteDriverDoc(id){
  const driver = doc(db, "drivers", id);
  // set the isDeleted field to true
  try {
    await updateDoc(driver, { isDeleted: true });
  } catch (error) {
    console.error('Error deleting the driver!', error);
  }
}
export async function editDriverDoc(updateList){//[id, name, phone, email, birth]
  const driver = doc(db, "drivers", updateList[0]);

  // set the isDeleted field to true
  try {
    await updateDoc(driver, { isDeleted: true });
  } catch (error) {
    console.error('Error deleting the driver!', error);
  }
}
function displaydriversTable() {
    const resultContainer = document.getElementById("sampleTable");
    // Create the table header
    const table = document.createElement('table');
    table.id = 'driver-table'
    table.innerHTML = `
        <thead>
            <tr>
            <th width="10"><input type="checkbox" id="all"></th>
            <th>ID tài xế</th>
            <th width="150">Họ và tên</th>
            <th width="300">Địa chỉ</th>
            <th>SĐT</th>
            <th width="100">Tính năng</th>
            </tr>
        </thead>
        <tbody id="driver-table-body"></tbody>
    `;
  
    // Append the table to the result container
    resultContainer.appendChild(table);
  
    // Update the table body with driver information
    const updateTable = (drivers) => {
      const tableBody = document.getElementById('driver-table-body');
      tableBody.innerHTML = '';
  
      drivers.forEach((driver) => {
        const row = tableBody.insertRow();
        row.innerHTML = `
        <td width="10"><input type="checkbox"></td>
        <td>${driver.id? driver.id: 'Unknown'}</td>
        <td>${driver.name? driver.name : 'Unknown'}</td>
        <td>${driver.address ? driver.address.stringName : 'Unknown'}</td>
        <td>${driver.phoneNumber? driver.phoneNumber : 'Unknown'}</td>
        <td><button class="btn btn-primary btn-sm trash" type="button" title="Delete"
            onclick= "deleteDriver(this)"><i class="fas fa-trash-alt"></i>
          </button>
          <button class="btn btn-primary btn-sm edit" type="button" title="Modify" id="show-emp"
            data-toggle="modal" data-target="#ModalUP"><i class="fas fa-edit"></i>
          </button>
        </td>
        `;
      });
    };
  
    const unsubscribe = onSnapshot(q, (querySnapshot) => {
      const drivers = [];
      querySnapshot.forEach((doc) => {
        drivers.push(doc.data());
      });
  
      updateTable(drivers);
    }, (error) => {
      console.error('Error fetching and updating drivers table:', error);
    });
  
    return unsubscribe;
}

export async function displayDrivers(field, value) {

  if(field == 'All'){
    var querySnapshot = await getDocs(driverRef);
  }
  else{
    var search_q = query(driverRef, where(field, "==", value));
    var querySnapshot = await getDocs(search_q);
    console.log(querySnapshot)
  }
  const resultContainer = document.getElementById("sampleTable");
  const tableBody = document.getElementById('driver-table-body');
  tableBody.innerHTML = '';

  querySnapshot.forEach((doc) => {
    const driver = doc.data();
    const row = tableBody.insertRow();
      row.innerHTML = `
      <td width="10"><input type="checkbox"></td>
      <td>${driver.id? driver.id: 'Unknown'}</td>
      <td>${driver.name? driver.name : 'Unknown'}</td>
      <td>${driver.address ? driver.address.stringName : 'Unknown'}</td>
      <td>${driver.phoneNumber? driver.phoneNumber : 'Unknown'}</td>
      <td><button class="btn btn-primary btn-sm trash" type="button" title="Delete"
          onclick= "deleteDriver(this)"><i class="fas fa-trash-alt"></i>
        </button>
        <button class="btn btn-primary btn-sm edit" type="button" title="Modify" id="show-emp"
          data-toggle="modal" data-target="#ModalUP"><i class="fas fa-edit"></i>
        </button>
      </td>
      `;
  });
}
displaydriversTable();

