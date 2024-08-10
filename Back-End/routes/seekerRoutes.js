const router = require("express").Router();
const SeekerController = require("../controllers/seekerController.js");

router.post("/register", SeekerController.registerSeeker);

module.exports = router;
