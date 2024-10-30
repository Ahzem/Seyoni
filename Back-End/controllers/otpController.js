const { generateOtp, saveTempUser } = require("../services/otpService");

exports.generateOtp = (req, res) => {
  const { phone } = req.body;
  if (!phone) {
    return res.status(400).json({ error: "Phone number is required" });
  }
  const otp = generateOtp(phone);
  res.status(200).json({ otp });
};

exports.saveTempUser = (req, res) => {
  const { phone, userData } = req.body;
  if (!phone || !userData) {
    return res
      .status(400)
      .json({ error: "Phone number and user data are required" });
  }
  saveTempUser(phone, userData);
  res.status(200).json({ message: "Temporary user data saved" });
};

exports.sendOtpToSeeker = (req, res) => {
  const { seekerId, otp } = req.body;
  if (!seekerId || !otp) {
    return res.status(400).json({ error: "Seeker ID and OTP are required" });
  }
  // Logic to send OTP to the seeker (e.g., using WebSocket or any other method)
  // For simplicity, we assume the OTP is sent successfully
  res.status(200).json({ message: "OTP sent to seeker" });
};
