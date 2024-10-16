const router = require("express").Router();
const seekerController = require("../controllers/seekerController");
const multer = require("multer");
const upload = multer({ storage: multer.memoryStorage() });
const authMiddleware = require("../middleware/authMiddleware");

router.post("/signup", seekerController.signUpSeeker);
router.post("/verifySignUpOtp", seekerController.verifySignUpOtp);
router.post("/resendOtp", seekerController.resendOtp);
router.post("/signin", seekerController.signInSeeker);
router.post("/signout", seekerController.signOutSeeker);
router.post("/check", seekerController.checkSeekerExists);
router.get("/all", seekerController.getAllSeekers);

router.get("/details", authMiddleware, seekerController.getSeekerDetails);
router.post(
  "/update",
  upload.single("profileImage"),
  seekerController.updateSeekerDetails
); // Add multer middleware here

module.exports = router;
