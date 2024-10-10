const Seeker = require("../../models/seekerModel");
const { generateOtp, saveTempUser } = require("../../services/otpService");
const generateToken = require("../../utils/generateToken");

exports.signUpSeeker = async (req, res) => {
  try {
    const { firstName, lastName, email, phone, password } = req.body;
    if (!firstName || !lastName || !phone) {
      return res
        .status(400)
        .json({ error: "firstName, lastName, and phone are required" });
    }

    const existingSeeker = await Seeker.findOne({
      $or: [{ email }, { phone }],
    });
    if (existingSeeker) {
      return res
        .status(409)
        .json({ error: "Email or phone number already exists" });
    }

    const seeker = new Seeker({ firstName, lastName, email, phone, password });
    await seeker.save();

    const token = generateToken(seeker._id);
    res.status(201).json({ token, seeker });
  } catch (error) {
    console.error("Error creating user:", error);
    res.status(500).json({ error: "Server error" });
  }
};
