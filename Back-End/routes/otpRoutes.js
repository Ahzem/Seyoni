const router = require("express").Router();
const otpController = require("../controllers/otpController");

router.post("/saveTempUser", otpController.saveTempUser);
router.post("/generateOtp", otpController.generateOtp);
router.post("/sendOtpToSeeker", otpController.sendOtpToSeeker);

module.exports = router;
