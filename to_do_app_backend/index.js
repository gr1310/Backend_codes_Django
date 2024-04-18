const app= require('./app.js')
const db= require('./config/db.js')
const UserModel= require("./models/user.model.js")
const port= 3000

app.get('/', (req,res)=>{
    res.send("Hello World")
});

app.listen(port,()=>{
    console.log('Server listeing')
});
