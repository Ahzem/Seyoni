const router = require("express").Router();
const SeekerController = require("../controllers/seekerController.js");

router.post("/signup", SeekerController.signUpSeeker);
router.post("/verifySignUpOtp", SeekerController.verifySignUpOtp);
router.post("/signin", SeekerController.signInSeeker);
router.post("/verifySignInOtp", SeekerController.verifySignInOtp);

module.exports = router;
