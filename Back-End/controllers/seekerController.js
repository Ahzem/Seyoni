const Seeker = require("../models/seekerModel");
const { PutObjectCommand, S3Client } = require("@aws-sdk/client-s3");
const s3 = new S3Client({ region: process.env.AWS_REGION });
const {
  generateOtp,
  saveTempUser,
  getTempUser,
  deleteTempUser,
  verifyOtp,
} = require("../services/otpService");
const generateToken = require("../utils/generateToken");
const bcrypt = require("bcrypt");

// Sign Up Seeker
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

// Verify Sign Up OTP
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
    res
      .status(201)
      .json({ message: "User registered successfully", seekerId: seeker._id });
  } catch (error) {
    console.error("Error verifying OTP:", error);
    res.status(500).json({ error: "Server error" });
  }
};

// Resend OTP
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

// Sign In Seeker
exports.signInSeeker = async (req, res) => {
  try {
    const { email, password } = req.body;
    const seeker = await Seeker.findOne({ email });
    if (!seeker || !(await seeker.comparePassword(password))) {
      return res.status(401).json({ error: "Invalid email or password" });
    }
    const token = generateToken(seeker._id);
    res.status(200).json({ token, seeker });
  } catch (error) {
    console.error("Error signing in:", error);
    res.status(500).json({ error: "Server error" });
  }
};

// Sign Out Seeker
exports.signOutSeeker = (req, res) => {
  // Invalidate the token or clear the session
  // This is a placeholder implementation
  res.status(200).json({ message: "User signed out successfully" });
};

// Check Seeker Exists
exports.checkSeekerExists = async (req, res) => {
  try {
    const { email, phone } = req.body;
    const existingSeeker = await Seeker.findOne({
      $or: [{ email }, { phone }],
    });
    if (existingSeeker) {
      return res.status(200).json({ exists: true });
    } else {
      return res.status(200).json({ exists: false });
    }
  } catch (error) {
    console.error("Error checking seeker existence:", error);
    res.status(500).json({ error: "Server error" });
  }
};

// Get All Seekers
exports.getAllSeekers = async (req, res) => {
  try {
    const seekers = await Seeker.find();
    res.status(200).json(seekers);
  } catch (error) {
    res.status(500).json({ message: "Failed to fetch seekers", error });
  }
};

// Fetch user details
exports.getSeekerDetails = async (req, res) => {
  try {
    const seeker = await Seeker.findById(req.user.id);
    if (!seeker) {
      return res.status(404).json({ error: "User not found" });
    }
    res.status(200).json(seeker);
  } catch (error) {
    console.error("Error fetching user details:", error);
    res.status(500).json({ error: "Server error" });
  }
};

// Update user details
exports.updateSeekerDetails = async (req, res) => {
  try {
    const { seekerId, firstName, lastName, phone, email, address, password } =
      req.body;

    if (!seekerId) {
      return res.status(400).json({ error: "Seeker ID is required" });
    }

    const seeker = await Seeker.findById(seekerId);

    if (!seeker) {
      return res.status(404).json({ error: "User not found" });
    }

    const isPasswordValid = await seeker.comparePassword(password);
    if (!isPasswordValid) {
      return res.status(400).json({ error: "Invalid password" });
    }

    if (req.file) {
      const file = req.file;
      const uploadParams = {
        Bucket: process.env.AWS_S3_BUCKET_NAME,
        Key: `profile-images/${seeker._id}-${file.originalname}`,
        Body: file.buffer,
        ContentType: file.mimetype,
      };
      const command = new PutObjectCommand(uploadParams);
      await s3.send(command);
      seeker.profileImageUrl = `https://${process.env.AWS_S3_BUCKET_NAME}.s3.amazonaws.com/${uploadParams.Key}`;
    }

    seeker.firstName = firstName;
    seeker.lastName = lastName;
    seeker.phone = phone;
    seeker.email = email;
    seeker.address = address;

    await seeker.save();
    res.status(200).json({ message: "User details updated successfully" });
  } catch (error) {
    res.status(500).json({ error: "Server error" });
  }
};
