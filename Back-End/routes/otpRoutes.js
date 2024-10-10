const router = require("express").Router();
const otpController = require("../controllers/otpController");

router.post("/generateOtp", otpController.generateOtp);
router.post("/saveTempUser", otpController.saveTempUser);

module.exports = router;
