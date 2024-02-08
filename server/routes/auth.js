const express = require("express");
const User = require("../models/user");
//jwt securly transmits information
const jwt = require("jsonwebtoken");
const auth = require("../middlewares/auth");

const authRouter = express.Router();

//creating api and use extension called thunder client to taste it
authRouter.post("/api/signup", async (req, res) => {
  try {
    const { name, email, profilePic } = req.body;

    //email already exist?
    let user = await User.findOne({ email: email });

    if (!user) {
      user = new User({
        email: email,
        profilePic: profilePic,
        name: name,
      });
      //storing the data
      user = await user.save();
    }
    //getting jwt token
    const token = jwt.sign({ id: user._id }, "passwordKey");
    res.json({ user: token });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.get("/", auth, async (req, res) => {
  const user = await User.findById(req.user);
  res.json({ user: user, token: req.token });
});

module.exports = authRouter;
