const Seeker = require("../../models/seekerModel");

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
