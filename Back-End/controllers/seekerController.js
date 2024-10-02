const Seeker = require("../models/seekerModel");
const {
  generateOtp,
  verifyOtp,
  saveTempUser,
  getTempUser,
  deleteTempUser,
} = require("../services/otpService");
const generateToken = require("../utils/generateToken");

exports.signUpSeeker = async (req, res) => {
  try {
    const { firstName, lastName, email, phone, password } = req.body;
    if (!firstName || !lastName || !phone) {
      return res
        .status(400)
        .json({ error: "firstName, lastName, and phone are required" });
    }

    // Check if user already exists
    const existingSeeker = await Seeker.findOne({ phone });
    if (existingSeeker) {
      return res.status(409).json({ error: "Phone number already exists" });
    }

    // Generate OTP and save user data temporarily
    generateOtp(phone);
    saveTempUser(phone, { firstName, lastName, email, phone, password });
    return res.status(200).send("OTP sent successfully");
  } catch (error) {
    console.error("Error creating user:", error);
    res.status(500).json({ error: "Server error" });
  }
};

exports.verifySignUpOtp = async (req, res) => {
  try {
    const { phone, otp } = req.body;
    console.log(`Verifying OTP for phone: ${phone} with OTP: ${otp}`);
    if (!verifyOtp(phone, otp)) {
      return res.status(400).json({ error: "Invalid OTP" });
    }

    // Retrieve temporary user data and save to database
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

exports.signInSeeker = async (req, res) => {
  try {
    const { email, password } = req.body;
    const seeker = await Seeker.findOne({ email });
    if (!seeker || !(await seeker.comparePassword(password))) {
      return res.status(401).json({ error: "Invalid email or password" });
    }

    // Generate OTP
    generateOtp(seeker.phone);
    return res.status(200).send("OTP sent successfully");
  } catch (error) {
    console.error("Error logging in user:", error);
    res.status(500).json({ error: "Server error" });
  }
};

exports.verifySignInOtp = async (req, res) => {
  try {
    const { email, otp } = req.body;
    const seeker = await Seeker.findOne({ email });
    console.log(`Verifying OTP for phone: ${seeker.phone} with OTP: ${otp}`);
    if (!seeker || !verifyOtp(seeker.phone, otp)) {
      return res.status(400).json({ error: "Invalid OTP" });
    }

    const token = generateToken(seeker._id);
    res.status(200).json({ status: true, token: token });
  } catch (error) {
    console.error("Error verifying OTP:", error);
    res.status(500).json({ error: "Server error" });
  }
};
