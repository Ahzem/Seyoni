const Seeker = require("../../models/seekerModel");
const {
  verifyOtp,
  getTempUser,
  deleteTempUser,
} = require("../../services/otpService");

exports.verifySignUpOtp = async (req, res) => {
  try {
    const { phone, otp } = req.body;
    if (!verifyOtp(phone, otp)) {
      return res.status(400).json({ error: "Invalid OTP" });
    }

    const tempUserData = getTempUser(phone);
    if (!tempUserData) {
      return res
        .status(400)
        .json({ error: "No user data found for this phone number" });
    }

    const seeker = new Seeker(tempUserData);
    await seeker.save();
    deleteTempUser(phone);
    res.status(201).json({ message: "User registered successfully" });
  } catch (error) {
    console.error("Error verifying OTP:", error);
    res.status(500).json({ error: "Server error" });
  }
};
