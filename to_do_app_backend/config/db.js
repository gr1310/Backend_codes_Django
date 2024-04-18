const {Client} = require('pg')
const client = new Client({
    host: "localhost",
    user: "postgres",
    port: 5432,
    password: "123456",
    database: "postgres"
});

client.connect();

module.exports= client






// CREATE TABLE todo(Email varchar(255), Password varchar(255))
// client.query(`SELECT * FROM todo`, (err,res)=>{
//     if(!err){
//         console.log(res.rows);
//     } else{
//         console.log(err.message);
//     }
//     client.end;
// })