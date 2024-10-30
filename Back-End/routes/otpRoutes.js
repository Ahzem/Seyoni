const router = require("express").Router();
const otpController = require("../controllers/otpController");

router.post("/generateOtp", otpController.generateOtp);
router.post("/saveTempUser", otpController.saveTempUser);
router.post("/sendOtpToSeeker", otpController.sendOtpToSeeker); // New endpoint

module.exports = router;
