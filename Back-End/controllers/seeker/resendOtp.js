const { generateOtp } = require("../../services/otpService");

exports.resendOtp = async (req, res) => {
  try {
    const { phone } = req.body;
    generateOtp(phone);
    res.status(200).send("OTP resent successfully");
  } catch (error) {
    console.error("Error resending OTP:", error);
    res.status(500).json({ error: "Server error" });
  }
};
