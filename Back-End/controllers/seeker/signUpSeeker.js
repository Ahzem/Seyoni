const Seeker = require("../../models/seekerModel");
const { generateOtp, saveTempUser } = require("../../services/otpService");

exports.signUpSeeker = async (req, res) => {
  try {
    const { firstName, lastName, email, phone, password } = req.body;
    if (!firstName || !lastName || !phone) {
      return res
        .status(400)
        .json({ error: "firstName, lastName, and phone are required" });
    }

    const existingSeeker = await Seeker.findOne({ phone });
    if (existingSeeker) {
      return res.status(409).json({ error: "Phone number already exists" });
    }

    generateOtp(phone);
    saveTempUser(phone, { firstName, lastName, email, phone, password });
    return res.status(200).send("OTP sent successfully");
  } catch (error) {
    console.error("Error creating user:", error);
    res.status(500).json({ error: "Server error" });
  }
};
