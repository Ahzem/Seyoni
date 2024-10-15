const router = require("express").Router();
const seekerController = require("../controllers/seekerController");

router.post("/signup", seekerController.signUpSeeker);
router.post("/verifySignUpOtp", seekerController.verifySignUpOtp);
router.post("/resendOtp", seekerController.resendOtp);
router.post("/signin", seekerController.signInSeeker);
router.post("/signout", seekerController.signOutSeeker);
router.post("/check", seekerController.checkSeekerExists);
router.get("/all", seekerController.getAllSeekers);

module.exports = router;
