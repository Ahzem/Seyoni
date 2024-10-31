const router = require("express").Router();
const otpController = require("../controllers/otpController");

router.post("/saveTempUser", otpController.saveTempUser);
router.post("/generateOtp", otpController.generateOtp);

module.exports = router;
