const { saveTempUser, generateOtp } = require("../services/otpService");

exports.saveTempUser = async (req, res) => {
  try {
    const { phone, userData } = req.body;
    await saveTempUser(phone, userData);
    res.status(200).send("Temporary user data saved successfully");
  } catch (error) {
    console.error("Error saving temporary user data:", error);
    res.status(500).json({ error: "Failed to save temporary user data" });
  }
};

exports.generateOtp = async (req, res) => {
  try {
    const { phone } = req.body;
    const otp = await generateOtp(phone);
    res.status(200).send("OTP generated successfully");
  } catch (error) {
    console.error("Error generating OTP:", error);
    res.status(500).json({ error: "Failed to generate OTP" });
  }
};

exports.sendOtpToSeeker = async (req, res) => {
  const { seekerId, otp } = req.body;
  if (!seekerId || !otp) {
    return res.status(400).json({ error: "Seeker ID and OTP are required" });
  }
  // Logic to send OTP to the seeker (e.g., using WebSocket or any other method)
  // For simplicity, we assume the OTP is sent successfully
  res.status(200).json({ message: "OTP sent to seeker" });
};
