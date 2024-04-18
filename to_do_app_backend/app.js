const userRouter= require("./routes/user.router")
const express= require('express');
const bodyParser= require('body-parser');

const app= express();

app.use(express.json());
app.use(bodyParser.json());

app.use('/',userRouter);

module.exports = app;
