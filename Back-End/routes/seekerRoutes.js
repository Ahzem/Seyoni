const router = require("express").Router();
const signUpSeeker = require("../controllers/seeker/signUpSeeker");
const verifySignUpOtp = require("../controllers/seeker/verifySignUpOtp");
const resendOtp = require("../controllers/seeker/resendOtp");
const signInSeeker = require("../controllers/seeker/signInSeeker");
const signOutSeeker = require("../controllers/seeker/signOutSeeker");
const checkSeekerExists = require("../controllers/seeker/checkSeekerExists");

router.post("/signup", signUpSeeker.signUpSeeker);
router.post("/verifySignUpOtp", verifySignUpOtp.verifySignUpOtp);
router.post("/resendOtp", resendOtp.resendOtp);
router.post("/signin", signInSeeker.signInSeeker);
router.post("/signout", signOutSeeker.signOutSeeker);
router.post("/check", checkSeekerExists.checkSeekerExists);

module.exports = router;
