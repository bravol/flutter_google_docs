const express = require("express");
const User = require("../models/user");

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
    //
    res.json({ user: user });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = authRouter;
