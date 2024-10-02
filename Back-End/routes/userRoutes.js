const express = require("express");
const router = express.Router();
const userController = require("../controllers/userController.js");

router.post("/sendOtp", userController.sendOtp);
router.post("/verifyOtp", userController.verifyOtp);

module.exports = router;
