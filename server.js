const express = require('express');
const mysql = require('mysql');
const path = require('path');
const cors = require('cors');
const { createBrotliCompress } = require('zlib');
const app = express();
const port = 3000;

// MySQL connection setup
const db = mysql.createConnection({
  host: 'localhost',
  port:3306,
  user: 'root',
  password: 'baasim_287',
  database: 'salonsystem'
});

db.connect(err => {
  if (err) {
    console.error('Error connecting to MySQL:', err);
    return;
  }
  console.log('Connected to MySQL');
});

// Middleware to parse JSON requests
app.use(express.json());
app.use(cors()); // Add CORS support
app.use(express.static(path.join(__dirname, './assets'))); // Serve static files

app.get('/api/data/:username/:password', (req, res) => {
  const { username, password } = req.params;
  const query = 'SELECT CASE WHEN EXISTS (SELECT * FROM tbladmin WHERE BINARY username = ? AND Password = ?) THEN "true" ELSE "false" END AS RecordExists';
  db.query(query, [username, password], (err, results) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    
    res.json({ success: results[0].RecordExists === 'true' });
  });
});

app.get('/api/fetchtimeslots', (req, res) => {
  const {EmployeeID, AptDate } = req.query;
  const query = 'SELECT * FROM tbltimeslots WHERE ID NOT IN (SELECT AptTimeID FROM tblappointment WHERE EmployeeID = ? AND AptDate = ?)';
  db.query(query, [EmployeeID, AptDate], (err, results) => {
    if (err) {
      console.error('API ERROR:', err);
      return res.status(500).json({ error: err.message });
    }
    res.json(results); // Send the results directly
  });
});

app.get('/api/fetchServiceNames', (req, res) => {
  const { status } = req.query
  const query = 'SELECT * FROM tblservices where IsActive = ?';
  db.query(query, [status],(err, results) => {
      if (err) {
          console.error('API ERROR:', err);
          res.status(500).json({ error: err.message });
          return;
      }
      res.json(results); // Send the results directly
  });
});

app.get('/api/barbers', (req, res) => {
  const query = 'SELECT * FROM tblemployee where status = "Present"';
  db.query(query, (err, results) => {
      if (err) {
          console.error('API ERROR:', err);
          res.status(500).json({ error: err.message });
          return;
      }
      res.json(results); // Send the results directly
  });
});

app.post('/api/AddAppointments', (req, res) => {
  const { employeeid, customerID, adate, atime, Remarks, totalPrice, selectedServices } = req.body;

  // Validate the input
  if (!employeeid || !adate || !atime || !selectedServices || selectedServices.length === 0 || !customerID) {
      return res.status(400).json({ error: 'EmployeeID, CustomerID, AptDate, AptTimeID, Services are required' });
  }

  // Insert appointment query
  const appointmentQuery = `
      INSERT INTO tblappointment (EmployeeID, CustomerID, AptDate, AptTimeID, Remarks, Total)
      VALUES (?, ?, ?, ?, ?, ?)
  `;
  db.query(appointmentQuery, [employeeid, customerID, adate, atime, Remarks, totalPrice], (err, result) => {
      if (err) {
          console.error('API ERROR (Appointment Query):', err);
          return res.status(500).json({ error: 'Error inserting appointment' });
      }

      const appointmentID = result.insertId;

      // Insert invoice query
      const invoiceQuery = 'INSERT INTO tblinvoice (AppointmentID) VALUES (?)';
      db.query(invoiceQuery, [appointmentID], (err, invoiceResult) => {
          if (err) {
              console.error('API ERROR (Invoice Query):', err);
              return res.status(500).json({ error: 'Error inserting invoice' });
          }

          const invoiceID = invoiceResult.insertId;

          // Insert billing records
          const billingValues = selectedServices.map(serviceID => `(${serviceID}, ${invoiceID})`).join(',');
          const billingQuery = `INSERT INTO tblbilling (ServiceID, InvoiceID) VALUES ${billingValues}`;

          db.query(billingQuery, (billingErr, billingResult) => {
              if (billingErr) {
                  console.error('API ERROR (Billing Query):', billingErr);
                  return res.status(500).json({ error: 'Error inserting billing records' });
              }

              return res.status(201).json({
                  success: true,
                  message: 'Appointment created successfully',
                  appointmentID,
                  customerID,
              });
          });
      });
  });
});


app.get('/api/AppointmentDetails', (req, res) => {
  const { aptno } = req.query;

  if (!aptno) {
    return res.status(400).json({ error: 'Appointment number (aptno) is required' });
  }

  const query = `
    SELECT 
      Apt.ID AS appointmentID,
      Inv.ID AS invoiceID,
      cust.Name,

      Apt.AptDate,
      ts.TimeSlots,
      Total 
    FROM 
      tblappointment Apt 
    JOIN 
      tblinvoice Inv ON Apt.ID = Inv.AppointmentID  
    JOIN 
      tblbilling bill ON Inv.ID = bill.InvoiceID 
    JOIN 
      tblservices Ser ON bill.ServiceID = Ser.ID 
    JOIN 
      tbltimeslots ts ON Apt.AptTimeID = ts.ID 
    JOIN
      tblcustomers cust on Apt.CustomerID=cust.ID 
    WHERE 
      Apt.ID = ? 
    `;

  db.query(query, [aptno], (err, results) => {
    if (err) {
      console.error('API ERROR:', err);
      return res.status(500).json({ error: err.message });
    }
    
    res.json(results); // Send the results directly
  });
});

app.post('/api/AddService', (req, res) => {
  const { serviceName, serviceDescription, Cost,service_stat } = req.body;

  // Validate the input
  if (!serviceName || !serviceDescription || !Cost) {
      return res.status(400).json({ error: 'Service Name, Service Description, and Cost are all required' });
  }
  
  const serviceQuery = 'INSERT INTO tblservices (ServiceName, Description, Cost, IsActive) VALUES (?, ?, ?, true)';
  db.query(serviceQuery, [serviceName, serviceDescription, Cost,service_stat], (err, result) => {
      if (err) {
          console.error('API ERROR:', err);
          return res.status(500).json({ error: err.message });
      }

      res.status(200).json({ message: 'Service added successfully' });
  });
});

app.put('/api/DeleteService/:serviceID', (req, res) => {
  const { status } = req.body
  const { serviceID } = req.params;
  
    const Query = 'update tblservices set IsActive = ? where ID = ?';
    db.query(Query, [status,serviceID], (err, result) => {
      if (err) {
        console.error('API ERROR:', err);
        return res.status(500).json({ error: err.message });
      }
      // Also delete related invoice and billing entries if needed
      res.status(200).json({ message: 'Service deleted successfully' });
    });
});

app.put('/api/updateService', (req, res) => {
  const {name, cost, description, id} = req.body;
  const serviceQuery = 'update tblservices set ServiceName = ?, Cost = ?, Description = ? where ID = ?';
  db.query(serviceQuery, [ name, cost, description, id], (err, result) => {
      if (err) {
          console.error('API ERROR:', err);
          return res.status(500).json({ error: err.message });
      }
      res.status(200).json({ message: 'Service updated successfully' });
  });
});

app.post('/api/AddEmployee', (req, res) => {
  const { employee_name, employee_number, employee_email, employee_salary,employee_appointdate,employee_status } = req.body;

  // Validate the input
  if (!employee_name|| !employee_number || !employee_email || !employee_salary) {
      return res.status(400).json({ error: 'All fields are to be filled' });
  }

  const EmpQuery = 'INSERT INTO tblemployee (EmpName, EmpNumber, EmpEmail, Salary, AppointDate, status ) VALUES (?, ?, ?, ?,current_date(),"Present")';
  db.query(EmpQuery, [employee_name, employee_number, employee_email, employee_salary,employee_appointdate,employee_status], (err, result) => {
      if (err) {
          console.error('API ERROR:', err);
          return res.status(500).json({ error: err.message });
      }

      res.status(200).json({ message: 'Employee added successfully' });
  });
});

app.put('/api/DeleteEmployee/:empID', (req, res) => {
  const { empID } = req.params;
  
    const Query = 'update tblemployee set status = "Resigned" where ID = ?';
    db.query(Query, [empID], (err, result) => {
      if (err) {
        console.error('API ERROR:', err);
        return res.status(500).json({ error: err.message });
      }
      // Also delete related invoice and billing entries if needed
      res.status(200).json({ message: 'Service deleted successfully' });
    });
});

app.put('/api/updateEmployee', (req, res) => {
  const {name, phone, salary, email, id} = req.body;
  const empupdateQuery = 'update tblemployee set EmpName = ?, EmpNumber= ?, Salary = ?,EmpEmail = ? where ID = ?';
  db.query(empupdateQuery, [ name, phone, salary, email, id], (err, result) => {
      if (err) {
          console.error('API ERROR:', err);
          return res.status(500).json({ error: err.message });
      }
      res.status(200).json({ message: 'Employee Details Updated' });
  });
});

app.get('/api/fetchAppointments', (req, res) => {
  const { Id, Name } = req.query; // Use req.query to access query parameters
  
  var name = "%"+Name+"%"
  let query = `SELECT A.ID, B.TimeSlots, D.Name, A.AptDate, A.Remarks, C.EmpName 
              FROM tblappointment A 
              JOIN tbltimeslots B ON A.AptTimeID = B.ID 
              JOIN tblemployee C ON A.EmployeeID = C.ID
              JOIN tblcustomers D ON A.CustomerID= D.ID`;

  const params = []; // Array to hold query parameters

  if (Id && Name) {
      query += ' WHERE A.ID = ? AND D.Name like ?';
      params.push(Id, name);
      
  } else if (Id) {
      query += ' WHERE A.ID = ?';
      params.push(Id);

  } else if (Name) {
      
      query += ' WHERE D.Name like ?';
      params.push(name);
  
  }

  query += ' ORDER BY  A.AptDate ASC';
  db.query(query,params, (err, results) => {
      if (err) {
          console.error('API ERROR:', err);
          res.status(500).json({ error: err.message });
          return;
      }
      res.json(results); // Send the results directly
  });
});

app.put('/api/UpdateRemarks', (req, res) => {
  const {Remarks,ID} = req.body;
  const Query = 'update tblappointment set Remarks = ? where ID = ?';
  db.query(Query, [ Remarks,ID], (err, result) => {
      if (err) {
          console.error('API ERROR:', err);
          return res.status(500).json({ error: err.message });
      }
      res.status(200).json({ message: 'Remarks Entered' });
  });
});

app.get('/api/fetchusernames', (req, res) => {
  const { custUsername} = req.query
  const query = 'select * from tblcustomers where username = ? ';
  db.query(query,[custUsername], (err, results) => {
      if (err) {
          console.error('API ERROR:', err);
          res.status(500).json({ error: err.message });
          return;
      }
      res.json(results); // Send the results directly
  });
});

app.post('/api/AddCustomer', (req, res) => {
  const { custName,custEmail,custNumber,custUsername,custPassword } = req.body;

  // Validate the input
  if (!custName|| !custEmail || !custNumber || !custUsername || !custPassword) {
    return res.status(400).json({ error: 'All fields are to be filled' });
  }

  const cust_Query = 'INSERT INTO tblcustomers (Name, Email, MobileNumber, username,Password ) VALUES (?, ?, ?, ?,?)';
  db.query(cust_Query, [custName,custEmail,custNumber,custUsername,custPassword], (err, result) => {
      if (err) {
          console.error('API ERROR:', err);
          return res.status(500).json({ error: err.message });
      }

      res.status(200).json({ message: 'Customer added successfully' });
  });
});

app.put('/api/updateCustomerCredits/:customerID', (req, res) => {
  const customerID = req.params.customerID;
  const { CreditPoints } = req.body;

  if (!customerID || CreditPoints == null) {
      return res.status(400).json({ error: 'Customer ID and Credit Points are required' });
  }

  const query = `UPDATE tblcustomers SET CreditPoints = ? WHERE ID = ?`;
  db.query(query, [CreditPoints, customerID], (err, result) => {
      if (err) {
          console.error('Error updating credit points:', err);
          return res.status(500).json({ error: 'Database error' });
      }
      res.status(200).json({ message: 'Credit points updated successfully', affectedRows: result.affectedRows });
  });
});

app.get('/api/logincust/:username/:password', (req, res) => {
  const { username, password } = req.params;
  const query = "SELECT CASE WHEN EXISTS (SELECT * FROM tblcustomers WHERE BINARY username = ? AND Password = ?) THEN (Select ID from tblcustomers where username = ?) ELSE 'false' END AS RecordExists";
  db.query(query, [username, password, username], (err, results) => {
    if (err) {
      res.status(500).json({ error: err.message });
      return;
    }
    res.json({ success: results[0].RecordExists != 'false' ? results[0].RecordExists : false });
    
  });
});

app.get('/api/fetchinvoices', (req, res) => {
  const { Id } = req.query; // Use req.query to access query parameters
  let query = `select A.ID, B.Name from tblappointment A join tblcustomers B on A.CustomerID = B.ID `;

  const params = []; // Array to hold query parameters

  if (Id) {
    query += ' WHERE A.ID = ?';
    params.push(Id);

}
  db.query(query,params, (err, results) => {
      if (err) {
          console.error('API ERROR:', err);
          res.status(500).json({ error: err.message });
          return;
      }
      res.json(results); // Send the results directly
  });
});

app.get('/api/fetchCustomers', (req, res) => {
  const { Name } = req.query; // Use req.query to access query parameters
  let query = `select * from tblcustomers`;
  var name = "%"+Name+"%"

  const params = []; // Array to hold query parameters

  if (Name) {
    query += ' WHERE Name like ?';
    params.push(name);

}
  db.query(query,params, (err, results) => {
      if (err) {
          console.error('API ERROR:', err);
          res.status(500).json({ error: err.message });
          return;
      }
      res.json(results); // Send the results directly
  });
});

app.get('/api/appointmentscount', (req, res) => {
  const query = 'SELECT count(*) as apt_count FROM tblappointment';
  db.query(query, (err, results) => {
      if (err) {
          console.error('API ERROR:', err);
          res.status(500).json({ error: err.message });
          return;
      }
      res.json(results[0]); // Send the results directly
  });
});

app.get('/api/customerscount', (req, res) => {
  const query = 'SELECT count(*) as cust_count FROM tblcustomers';
  db.query(query, (err, results) => {
      if (err) {
          console.error('API ERROR:', err);
          res.status(500).json({ error: err.message });
          return;
      }
      res.json(results[0]); // Send the results directly
  });
});

app.get('/api/servicescount', (req, res) => {
  const query = 'SELECT count(*) as ser_count FROM tblservices';
  db.query(query, (err, results) => {
      if (err) {
          console.error('API ERROR:', err);
          res.status(500).json({ error: err.message });
          return;
      }
      res.json(results[0]); // Send the results directly
  });
});

app.get('/api/todaysales', (req, res) => {

  const query = `SELECT 
          SUM(Ser.cost) AS today_sales
      FROM 
          tblappointment Apt 
      JOIN 
          tblinvoice Inv ON Apt.ID = Inv.AppointmentID  
      JOIN 
          tblbilling bill ON Inv.ID = bill.InvoiceID 
      JOIN 
          tblservices Ser ON bill.ServiceID = Ser.ID 
      JOIN 
          tbltimeslots ts ON Apt.AptTimeID = ts.ID 
      JOIN
          tblcustomers cust ON Apt.CustomerID = cust.ID 
      WHERE 
          Apt.AptDate = CURDATE();`;

  db.query(query, (err, results) => {
      if (err) {
          console.error('API ERROR:', err);
          res.status(500).json({ error: err.message });
          return;
      }
      
      res.json(results[0]); // Send the results directly
  });
});

app.get('/api/lastweeksales', (req, res) => {

  const query = `SELECT 
          SUM(Ser.cost) AS lastweek_sales
      FROM 
          tblappointment Apt 
      JOIN 
          tblinvoice Inv ON Apt.ID = Inv.AppointmentID  
      JOIN 
          tblbilling bill ON Inv.ID = bill.InvoiceID 
      JOIN 
          tblservices Ser ON bill.ServiceID = Ser.ID 
      JOIN 
          tbltimeslots ts ON Apt.AptTimeID = ts.ID 
      JOIN
          tblcustomers cust ON Apt.CustomerID = cust.ID 
      WHERE 
          YEARWEEK(Apt.AptDate, 1) = YEARWEEK(CURDATE(), 1)`;

  db.query(query, (err, results) => {
      if (err) {
          console.error('API ERROR:', err);
          res.status(500).json({ error: err.message });
          return;
      }
      
      res.json(results[0]); // Send the results directly
  });
});

app.get('/api/totalsales', (req, res) => {

  const query = `SELECT 
          SUM(Ser.cost) AS total_sales
      FROM 
          tblappointment Apt 
      JOIN 
          tblinvoice Inv ON Apt.ID = Inv.AppointmentID  
      JOIN 
          tblbilling bill ON Inv.ID = bill.InvoiceID 
      JOIN 
          tblservices Ser ON bill.ServiceID = Ser.ID 
      JOIN 
          tbltimeslots ts ON Apt.AptTimeID = ts.ID 
      JOIN
          tblcustomers cust ON Apt.CustomerID = cust.ID 
      `;

  db.query(query, (err, results) => {
      if (err) {
          console.error('API ERROR:', err);
          res.status(500).json({ error: err.message });
          return;
      }
      
      res.json(results[0]); // Send the results directly
  });
});

app.get('/api/creditpoints/:id', (req, res) => {
  const id = req.params.id;

  const query = `SELECT CreditPoints FROM tblcustomers WHERE ID = ?`;

  db.query(query, [id], (err, results) => {
      if (err) {
          console.error('API ERROR:', err);
          res.status(500).json({ error: err.message });
          return;
      }
      if (results.length === 0) {
          res.json({ CreditPoints: 0 }); // Default to 0 if no records found
          return;
      }
      res.json(results[0]); // Send the first row
  });
});
// Start the server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
