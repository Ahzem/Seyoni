const { registerSeeker } = require("../services/seekerServices");

exports.registerSeeker = async (req, res) => {
  try {
    const newSeeker = await registerSeeker(req.body);
    res
      .status(201)
      .json({ message: "User created successfully", user: newSeeker });
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
};
