// import mongoose from "mongoose";
// import db from "../config/db.js";

const pg= require('pg')
const client= require('../config/db.js')


// const { Schema } = pg;

// const userSchema = new Schema({
//     email:{
//         type:String,
//         lowercase:true,
//         required:true,
//         unique:true
//     },
//     password:{
//         type:String,
//         required:true,
//     }
// });

// const UserModel= db.model('user',userSchema)

client.query(`CREATE TABLE IF NOT EXISTS users_new (
    email TEXT PRIMARY KEY,
    password TEXT NOT NULL
  );`, (err,res)=>{
    if(!err){
        console.log("Table created successfully");
    } else{
        console.log(err.message);
    }
    client.end;
});


module.exports= client