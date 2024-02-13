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

//getting the documents API
documentRouter.get("/docs/me", auth, async (req, res) => {
  try {
    let documents = await Document.find({ uid: req.user });
    res.json(documents);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

//updating the title of the document
documentRouter.post("/doc/title", auth, async (req, res) => {
  try {
    const { id, title } = req.body;
    const document = await Document.findByIdAndUpdate(id, { title });

    res.json(document);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

//getting the updated document from the database
documentRouter.get("/doc/:id", auth, async (req, res) => {
  try {
    const document = await Document.findById(req.params.id);
    res.json(document);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = documentRouter;
