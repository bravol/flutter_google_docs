const mongoose = require("mongoose");

//the structure of our user
const userSchema = mongoose.Schema({
  name: {
    type: String,
    required: true,
    // trim:true,
  },
  email: {
    type: String,
    required: true,
  },
  profilePic: {
    type: String,
    required: true,
  },
});

const User = mongoose.model("User", userSchema);
module.exports = User; //esport to be public
