const router = require("express").Router();
const SeekerController = require("../controllers/seekerController.js");

router.post("/register", SeekerController.registerSeeker);
router.post("/login", SeekerController.loginSeeker);

module.exports = router;
