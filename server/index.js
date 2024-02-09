const express = require("express");
const mongoose = require("mongoose");
const authRouter = require("./routes/auth");
require("dotenv").config();

const cors = require("cors");
const documentRouter = require("./routes/document");

const PORT = process.env.PORT | 3001;
// const password = process.env.MONGO_DB_PASSWORD;

const app = express();

//adding middle ware so that the client side can also know
app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(documentRouter);
//connecting our database
// const DB = `mongodb+srv://bravol:${password}@cluster0.gdnnpiw.mongodb.net/?retryWrites=true&w=majority`;
const DB = `mongodb+srv://bravol:CISSYbravol75@cluster0.gdnnpiw.mongodb.net/?retryWrites=true&w=majority`;

// // define api(creating api using express)

// app.post("/api/signup", (req, res) => {});

// app.get("/api/get", (req, res) => {});

// // GET, POST, UPDATE, DELETE

mongoose
  .connect(DB)
  .then(() => {
    console.log("connected to database");
  })
  .catch((err) => {
    console.log(err);
  });

//async=.await
//.then((dtat)=>)

app.listen(PORT, "0.0.0.0", () => {
  console.log(`connected at port ${PORT}`);
  console.log("this is good");
});
