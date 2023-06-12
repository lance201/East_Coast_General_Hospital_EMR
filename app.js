/*
    SETUP
*/

// Express
var express = require('express');
var app = express();
app.use(express.json());
app.use(express.urlencoded({extended: true}));

PORT = 8035;

// Database
var db = require('./database/db-connector');

// Handlebars
var { engine } = require('express-handlebars');
var helpers = require('handlebars-helpers')();
app.engine('.hbs', engine({extname: '.hbs'}));
app.set('view engine', '.hbs');

app.use(express.static('public'));


/*
    ROUTES
*/
app.get('/', function(req, res)
    {
        res.render('index');
    });


app.get('/patient', function(req, res)
    {  
        let query1 = "SELECT * FROM Patient;";               

        db.pool.query(query1, function(error, rows, fields){    

            res.render('patient', {data: rows});                  
        })                                                      
    });                         

app.get('/visit', function(req, res)
    {  
        let query1;
        if (req.query.patient_name === undefined)
            {
                query1 = "SELECT * FROM Visit;";   
            }
        else if (req.query.patient_name === "null")
            {
                query1 = "SELECT * FROM Visit;";   
            }
        else
            {
                query1 = `SELECT * FROM Visit WHERE 
                (SELECT Patient.patient_id FROM Patient 
                INNER JOIN Visit 
                ON Patient.patient_id = Visit.patient_id WHERE "${req.query.patient_name}" = first_name LIMIT 1) = patient_id`
            }     
        let query2 = "SELECT first_name FROM Patient;";
        let query3 = "SELECT patient_id FROM Patient;";
        let query4 = "SELECT doctor_id FROM Doctor;";
        let query5 = "SELECT room_id FROM Room;";
        let query6 = "SELECT requisition_id FROM Requisition;";   

        db.pool.query(query1, function(error, rows, fields){    

            let visit = rows;

            db.pool.query(query2, (error, rows, fields) => {
                                           
                let patients = rows;

                db.pool.query(query3, (error, rows, fields) => {
                                           
                    let patientsid = rows;
                
                    db.pool.query(query4, (error, rows, fields) => {
                                           
                        let doctors = rows;
                    
                        db.pool.query(query5, (error, rows, fields) => {
                                           
                            let rooms = rows;

                            db.pool.query(query6, (error, rows, fields) => {
                                           
                                let requisitions = rows;

                                return res.render('visit', {data: visit, patients: patients, patientsid: patientsid, doctors: doctors, rooms: rooms, requisitions: requisitions});
                            })
                        })
                    })
                })
            })                     
        })                                                      
    });  

app.get('/nurse_visit', function(req, res)
    {  
        let query1 = "SELECT * FROM Nurse_Visit;";
        let query2 = "SELECT record_id FROM Visit;";
        let query3 = "SELECT nurse_id FROM Nurse;";                 

        db.pool.query(query1, function(error, rows, fields){
            
            let nurse_visit = rows;

            db.pool.query(query2, (error, rows, fields) => {

                let visits = rows;

                db.pool.query(query3, (error, rows, fields) => {
                    
                    let nurses = rows;
    
                    res.render('nurse_visit', {data: nurse_visit, visits: visits, nurses: nurses});
                })
            })                  
        })                                                      
    });  

app.get('/nurse', function(req, res)
    {  
        let query1 = "SELECT * FROM Nurse;";
        let query2 = "SELECT department_name FROM Department;";                 

        db.pool.query(query1, function(error, rows, fields){    

            let nurse = rows;

            db.pool.query(query2, (error, rows, fields) => {
            
                let departments = rows;
                return res.render('nurse', {data: nurse, departments: departments});
            })                  
        })                                                      
    }); 

app.get('/doctor', function(req, res)
    {  
        let query1 = "SELECT * FROM Doctor;";
        let query2 = "SELECT department_name FROM Department;";               

        db.pool.query(query1, function(error, rows, fields){
            
            let doctor = rows;

            db.pool.query(query2, (error, rows, fields) => {
            
                let departments = rows;
                return res.render('doctor', {data: doctor, departments: departments});
            })                 
        })                                                      
    }); 

app.get('/room', function(req, res)
    {  
        let query1 = "SELECT * FROM Room;";
        let query2 = "SELECT department_name FROM Department;";                

        db.pool.query(query1, function(error, rows, fields){
            
            let room = rows;

            db.pool.query(query2, (error, rows, fields) => {
            
                let departments = rows;

                res.render('room', {data: room, departments, departments});
            })                  
        })                                                      
    }); 

app.get('/department', function(req, res)
    {  
        let query1 = "SELECT * FROM Department;";               

        db.pool.query(query1, function(error, rows, fields){    

            res.render('department', {data: rows});                  
        })                                                      
    }); 

app.get('/requisition', function(req, res)
    {  
        let query1 = "SELECT * FROM Requisition;";               

        db.pool.query(query1, function(error, rows, fields){    

            res.render('requisition', {data: rows});                  
        })                                                      
    }); 


app.post('/patient', function(req, res){
    let data = req.body;

    query1 = `INSERT INTO Patient (last_name, first_name, social_security, date_of_birth, address, insurance, phone_number, primary_doctor) 
    VALUES ('${data['last_name']}', '${data['first_name']}', '${data['social_security']}', '${data['date_of_birth']}', 
    '${data['address']}', '${data['insurance']}', '${data['phone_number']}', '${data['primary_doctor']}')`;
    db.pool.query(query1, function(error, rows, fields){

        if (error) {

            console.log(error)
            res.sendStatus(400);
        }

        else
        {
            res.redirect('/patient');
        }
    })
})

app.post('/visit', function(req, res){
    let data = req.body;
    let req_id = data.requisition_id

    if (req_id === 'null'){
        req_id = null
    } else {
        req_id = `${data.requisition_id}`
    }
    
    query1 = `INSERT INTO Visit (patient_id, doctor_id, room_id, requisition_id, date, height, weight, vital_sign, chief_complaint, physical_exam, treatment, diagnosis) 
    VALUES ('${data.patient_id}', '${data.doctor_id}', '${data.room_id}', ${req_id}, '${data.date}', '${data.height}', '${data.weight}', '${data.vital_sign}', 
    '${data.chief_complaint}', '${data.physical_exam}', '${data.treatment}', '${data.diagnosis}')`;
    

    db.pool.query(query1, function(error, rows, fields){

        if (error) {

            console.log(error)
            res.sendStatus(400);
        }

        else
        {
            res.redirect('/visit');
        }
    })
})

app.post('/nurse_visit', function(req, res){
    let data = req.body;

    query1 = `INSERT INTO Nurse_Visit (record_id, nurse_id) VALUES ('${data['record_id']}', '${data['nurse_id']}')`;
    db.pool.query(query1, function(error, rows, fields){

        if (error) {

            console.log(error)
            res.sendStatus(400);
        }
        else
        {
            res.redirect('/nurse_visit');
        }
    })
})

app.post('/nurse', function(req, res){
    let data = req.body;


    query1 = `INSERT INTO Nurse (last_name, first_name, department_name, phone_number) 
    VALUES ('${data['last_name']}', '${data['first_name']}', '${data['department_name']}', '${data['phone_number']}')`;
    db.pool.query(query1, function(error, rows, fields){

        if (error) {

            console.log(error)
            res.sendStatus(400);
        }
        else
        {
            res.redirect('/nurse');
        }
    })
})

app.post('/doctor', function(req, res){
    let data = req.body;

    query1 = `INSERT INTO Doctor (last_name, first_name, specialty, department_name, phone_number) 
    VALUES ('${data['last_name']}', '${data['first_name']}', '${data['specialty']}', '${data['department_name']}', '${data['phone_number']}')`;
    db.pool.query(query1, function(error, rows, fields){

        if (error) {

            console.log(error)
            res.sendStatus(400);
        }
        else
        {
            res.redirect('/doctor');
        }
    })
})

app.post('/room', function(req, res){
    let data = req.body;

    query1 = `INSERT INTO Room (room_id, floor, department_name) 
    VALUES ('${data['room_id']}', '${data['floor']}', '${data['department_name']}')`;
    db.pool.query(query1, function(error, rows, fields){

        if (error) {

            console.log(error)
            res.sendStatus(400);
        }
        else
        {
            res.redirect('/room');
        }
    })
})

app.post('/department', function(req, res){
    let data = req.body;

    query1 = `INSERT INTO Department (department_name, phone_number) 
    VALUES ('${data['department_name']}','${data['phone_number']}')`;
    db.pool.query(query1, function(error, rows, fields){

        if (error) {

            console.log(error)
            res.sendStatus(400);
        }
        else
        {
            res.redirect('/department');
        }
    })
})

app.post('/requisition', function(req, res){
    let data = req.body;

    query1 = `INSERT INTO Requisition (order_name, result)
    VALUES ('${data['order_name']}','${data['result']}')`;
    db.pool.query(query1, function(error, rows, fields){

        if (error) {

            console.log(error)
            res.sendStatus(400);
        }
        else
        {
            res.redirect('/requisition');
        }
    })
})

/* Display one person for the specific purpose of updating people */
app.get('/update_patient', function(req, res) {
        
        let patient_id = req.query.patient_id;
    
        let query1 = `SELECT * FROM Patient WHERE patient_id = ${patient_id}`;               

        db.pool.query(query1, function(error, rows, fields){    

            if (error) {
                console.log(error);
                res.sendStatus(400);

            } else {
                console.log(rows);
                let patient = rows[0];
                res.render('update_patient', { patient: patient });
            }                  
        })                                                      
    }); 


/* The URI that update data is sent to in order to update a person */
app.post('/updated_patient', function (req, res) {
    let data = req.body;
    console.log('data', req.body);

    let query1 = `UPDATE Patient 
                 SET last_name='${data.last_name}', first_name='${data.first_name}', social_security='${parseInt(data.social_security)}', date_of_birth='${data.date_of_birth}', address='${data.address}', insurance='${data.insurance}', phone_number='${parseInt(data.phone_number)}', primary_doctor='${data.primary_doctor}' 
                 WHERE patient_id = ${data.patient_id}`;

    db.pool.query(query1, function (error, rows, fields) {
        if (error) {
            console.log(error);
            res.sendStatus(400);

        } else {
            console.log(query1)
            res.redirect('/patient');

        }
    });
});

// DELETE

// Deletes an existing patient.
app.get('/delete_patient', function (req, res) {
    let patient_id = req.query.patient_id;

    let query1 = `DELETE FROM Patient WHERE patient_id = ${patient_id};`;

    db.pool.query(query1, function (error, rows, fields) {
        if (error) {
            console.log(error);
            res.sendStatus(400);
        } else {
            res.redirect('/patient');
        }
    });
});

// Deletes an existing M:M relationship for nurse and visit.
app.get('/delete_nursevisit', function (req, res) {
    let nurse_id = req.query.nurse_id;
    let record_id = req.query.record_id;

    let query1 = `DELETE FROM Nurse_Visit WHERE nurse_id = ${nurse_id} AND record_id = ${record_id};`;

    db.pool.query(query1, function (error, rows, fields) {
        if (error) {
            console.log(error);
            res.sendStatus(400);
        } else {
            res.redirect('/nurse_visit');
        }
    });
});

/*
    LISTENER
*/
app.listen(PORT, function(){
    console.log('Express started on http://localhost:' + PORT + '; press Ctrl-C to terminate.')
});