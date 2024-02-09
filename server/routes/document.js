const Document = require("../models/document");
const express = require("express");
const auth = require("../middlewares/auth");

const documentRouter = express.Router();

// creating the document API //auth is the middleware that validates and also helps us to get the req.user since auth can access the token of the user
documentRouter.post("/doc/create", auth, async (req, res) => {
  try {
    const { createdAt } = req.body; //it can be some delay we take from client to server side
    let document = new Document({
      uid: req.user,
      title: "New Document",
      createdAt,
    });

    document = await document.save();
    res.json(document);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = documentRouter;
