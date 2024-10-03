const { generateOtp, verifyOtp } = require("../services/otpService");

module.exports.sendOtp = async (req, res) => {
  const number = req.body.number;
  const OTP = generateOtp(number);
  return res.status(200).send("OTP sent successfully");
};

module.exports.verifyOtp = async (req, res) => {
  const { number, otp } = req.body;
  const isValid = verifyOtp(number, otp);
  if (!isValid) {
    return res.status(400).send("Your OTP is wrong");
  }
  return res.status(200).send("OTP verified successfully");
};
