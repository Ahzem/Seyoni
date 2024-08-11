const router = require("express").Router();
const SeekerController = require("../controllers/seekerController.js");

router.post("/signup", SeekerController.signUpSeeker);
router.post("/signin", SeekerController.SignInSeeker);

module.exports = router;
