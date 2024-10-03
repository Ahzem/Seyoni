const Seeker = require("../../models/seekerModel");
const generateToken = require("../../utils/generateToken");

exports.signInSeeker = async (req, res) => {
  try {
    const { email, password } = req.body;
    const seeker = await Seeker.findOne({ email });
    if (!seeker || !(await seeker.comparePassword(password))) {
      return res.status(401).json({ error: "Invalid email or password" });
    }
    const token = generateToken(seeker._id);
    res.status(200).json({ token });
  } catch (error) {
    console.error("Error signing in:", error);
    res.status(500).json({ error: "Server error" });
  }
};
