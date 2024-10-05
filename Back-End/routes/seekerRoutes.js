const router = require("express").Router();
const {
  signUpSeeker,
  verifySignUpOtp,
  resendOtp,
  signInSeeker,
  signOutSeeker,
} = require("../controllers");

router.post("/signup", signUpSeeker.signUpSeeker);
router.post("/verifySignUpOtp", verifySignUpOtp.verifySignUpOtp);
router.post("/resendOtp", resendOtp.resendOtp);
router.post("/signin", signInSeeker.signInSeeker);
router.post("/signout", signOutSeeker.signOutSeeker);

module.exports = router;
