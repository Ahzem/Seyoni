const { registerSeeker } = require("../services/seekerServices");

exports.registerSeeker = async (req, res) => {
  try {
    const { firstName, lastName, email, phone, password } = req.body;
    if (!firstName || !lastName || !phone) {
      return res
        .status(400)
        .json({ error: "firstName, lastName, and phone are required" });
    }
    const seeker = await registerSeeker({
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
