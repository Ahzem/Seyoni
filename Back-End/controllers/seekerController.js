const { signUpSeeker, signInSeeker } = require("../services/seekerServices");
const generateToken = require("../utils/generateToken");

exports.signUpSeeker = async (req, res) => {
  try {
    const { firstName, lastName, email, phone, password } = req.body;
    if (!firstName || !lastName || !phone) {
      return res
        .status(400)
        .json({ error: "firstName, lastName, and phone are required" });
    }
    const seeker = await signUpSeeker({
      firstName,
      lastName,
      email,
      phone,
      password,
    });
    res.status(201).json(seeker);
  } catch (error) {
    console.error("Error creating user:", error);
    if (error.code === 11000) {
      // Duplicate key error
      return res.status(409).json({ error: "Phone number already exists" });
    }
    res.status(500).json({ error: "Server error" });
  }
};

exports.signInSeeker = async (req, res) => {
  try {
    const { email, password } = req.body;

    const seeker = await signInSeeker({ email, password });
    if (!seeker) {
      return res.status(404).json({ error: "User not found" });
    }

    const token = generateToken(seeker._id);

    res.status(200).json({ status: true, token: token });
  } catch (error) {
    console.error("Error logging in user:", error);
    if (
      error.message === "User not found" ||
      error.message === "Invalid password"
    ) {
      return res.status(401).json({ error: error.message });
    }
    res.status(500).json({ error: "Server error" });
  }
};
